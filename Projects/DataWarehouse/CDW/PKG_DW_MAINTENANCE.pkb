CREATE OR REPLACE PACKAGE BODY pkg_dw_maintenance AS
/*
  Procedures for Data Warehouse maintenance
   
  Change history
  ------------------------------------------------------------------------------
  06-MAR-2018, OK: added procedure REFRESH_INCREMENTAL; 
  16-FEB-2018, OK added procedures INIT_MAX_CIDS and RECORD_MAX_CIDS;
  01-FEB-2018, OK: created
*/
  PROCEDURE init_max_cids(p_table_name IN VARCHAR2) IS-- initializes MAX_CIDS array;
  BEGIN
    FOR r IN
    (
      SELECT nw.network, NVL(etl.max_cid, 0) max_cid
      FROM dim_hc_networks nw
      LEFT JOIN log_incremental_data_load etl ON etl.table_name = p_table_name AND etl.network = nw.network
    )
    LOOP
      dwm.max_cids(r.network) := r.max_cid;
    END LOOP;
  END;
  
  
  PROCEDURE record_max_cids(p_table_name IN VARCHAR2) IS -- saves new MAX_CID values in the table ETL_MAX_CIDS;
    idx VARCHAR2(30);
  BEGIN
    idx := dwm.max_cids.FIRST;
    
    WHILE idx IS NOT NULL LOOP
      MERGE INTO log_incremental_data_load t
      USING
      (
        SELECT
          p_table_name AS table_name,
          idx AS network,
          dwm.max_cids(idx) AS max_cid
        FROM dual
      ) s
      ON (t.table_name = s.table_name AND t.network = s.network)
      WHEN MATCHED THEN UPDATE
      SET t.prev_max_cid = t.max_cid, t.max_cid = s.max_cid, t.load_dt = SYSDATE
      WHERE t.max_cid <> s.max_cid
      WHEN NOT MATCHED THEN INSERT(dbname, schema_name, table_name, network, max_cid, load_dt)
      VALUES
      (
        CASE WHEN s.table_name LIKE 'FACT%' THEN 'HIGGSDV3' ELSE s.network||'DW01' END,
        CASE WHEN s.table_name LIKE 'FACT%' THEN 'CDW' ELSE 'UD_MASTER' END,
        s.table_name, s.network, s.max_cid, SYSDATE
      );
      
      idx := dwm.max_cids.NEXT(idx);
    END LOOP;
  END;
  
  
  PROCEDURE refresh_data(p_condition IN VARCHAR2 DEFAULT NULL) IS
    rcur    SYS_REFCURSOR;
    rec     cnf_dw_refresh%ROWTYPE;
    v_msg   VARCHAR2(2048);
  BEGIN
    xl.open_log('DWM.REFRESH_DATA', 'Refreshing DW'||CASE WHEN p_condition IS NOT NULL THEN ': '||p_condition END, TRUE);
    
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    
    OPEN rcur FOR
    'SELECT * FROM cnf_dw_refresh'||
    CASE WHEN p_condition IS NOT NULL THEN '
    '||p_condition 
    END || '
    ORDER BY etl_step_num';
    
    LOOP
      FETCH rcur INTO rec;
      EXIT WHEN rcur%NOTFOUND;
      
      etl.add_data
      (
        p_operation => rec.operation,
        p_tgt => rec.target_table,
        p_src => rec.data_source,
        p_whr => rec.where_clause,
        p_uk_col_list => rec.uk_col_list,
        p_changes_only => 'Y',
        p_delete_cnd => rec.delete_condition,
        p_errtab => rec.error_table,
        p_commit_at => -1
      );
    END LOOP;
    
    CLOSE rcur;
    
    SELECT
      'Successfully completed'||CHR(10)||
      '-------------------------------------------------------------------------'||CHR(10)||
      concat_v2_set
      (
        CURSOR
        (
          SELECT action||':'||CHR(9)||comment_txt 
          FROM dbg_log_data
          WHERE proc_id = xl.get_current_proc_id
          AND action LIKE 'Adding data to%'
          AND comment_txt NOT LIKE 'Operation%'
          ORDER BY tstamp
        ),
        CHR(10)
      )
    INTO v_msg FROM dual;
    
    xl.close_log(v_msg);
  EXCEPTION
   WHEN OTHERS THEN
    ROLLBACK;
    xl.close_log(SQLERRM, TRUE);
    CLOSE rcur;
    RAISE;
  END;
  
  
  PROCEDURE refresh_full IS
  BEGIN
    refresh_data('WHERE target_table NOT IN (''PROC'',''VISIT'',''VISIT_SEGMENT'',''VISIT_SEGMENT_VISIT_LOCATION'',''EVENT'',''PROC_EVENT'',''PROC_EVENT_ARCHIVE'',''RESULT'') AND target_table NOT LIKE ''FACT%''');
  END;


  PROCEDURE refresh_incremental IS
  BEGIN
    refresh_data('WHERE target_table IN (''PROC'',''VISIT'',''VISIT_SEGMENT'',''VISIT_SEGMENT_VISIT_LOCATION'',''EVENT'',''PROC_EVENT'',''PROC_EVENT_ARCHIVE'',''RESULT'')');
  END;
END;
/
