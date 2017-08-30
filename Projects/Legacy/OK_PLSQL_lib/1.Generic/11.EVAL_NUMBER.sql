CREATE OR REPLACE FUNCTION eval_number(i_string IN VARCHAR2) RETURN NUMBER AS
  ret NUMBER;
BEGIN
  EXECUTE IMMEDIATE 'BEGIN :ret := '||i_string||'; END;' USING OUT ret;
  RETURN ret;
END;
/
GRANT EXECUTE ON eval_number TO PUBLIC;
CREATE OR REPLACE PUBLIC SYNONYM eval_number FOR eval_number;
 