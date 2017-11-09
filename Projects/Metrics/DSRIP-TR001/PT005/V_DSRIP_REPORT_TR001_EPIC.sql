CREATE OR REPLACE VIEW v_dsrip_report_tr001_epic AS
SELECT
  dt.report_period_start_dt,
  src.*,
  ROW_NUMBER() OVER(PARTITION BY visit_id ORDER BY etl_load_date DESC) rnum
FROM
(
  SELECT
    TRUNC(NVL(TO_DATE(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER')), SYSDATE), 'MONTH') report_period_start_dt
  FROM dual 
) dt
JOIN epic_clarity.dsrip_bh_follow_up_visit src
  ON src.etl_load_date = (SELECT MAX(etl_load_date) FROM epic_clarity.dsrip_bh_follow_up_visit)
 AND src.discharge_dt >= ADD_MONTHS(dt.report_period_start_dt, -2)
 AND src.discharge_dt < ADD_MONTHS(dt.report_period_start_dt, -1);