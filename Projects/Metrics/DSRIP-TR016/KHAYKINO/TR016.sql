rem You call this script from SQL Plus like this:
rem SQL> @tr016.sql 01-FEB-2018
rem The parameter is optional. By default, it will run for the current month.

set line 100
set verify off
set feedback off
set serverout on
whenever sqlerror exit 1

ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION SET STAR_TRANSFORMATION_ENABLED=TRUE;

column 1 new_value 1
select '' "1" from dual where rownum = 0;
define MON='&1'

begin
  dbms_session.set_identifier(NVL('&MON', TRUNC(SYSDATE, 'MONTH')));
  dbms_output.put_line('Month: '||SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'));
end;
/

TRUNCATE TABLE dsrip_tr016_a1c_glucose_rslt;
TRUNCATE TABLE dsrip_tr016_payers;
TRUNCATE TABLE dsrip_tr016_pcp_info;

@Insert_TR016_A1C_GLUCOSE_RSLT.sql
@Insert_TR016_PAYERS.sql
@Insert_TR016_PCP_INFO.sql

exit