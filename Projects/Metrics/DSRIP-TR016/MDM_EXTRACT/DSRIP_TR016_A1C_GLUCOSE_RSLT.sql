DROP TABLE dsrip_tr016_a1c_glucose_rslt PURGE;

CREATE GLOBAL TEMPORARY
TABLE dsrip_tr016_a1c_glucose_rslt
(
  NETWORK            VARCHAR2(3) NOT NULL,
  FACILITY_ID        NUMBER(12) NOT NULL,
  PATIENT_ID         NUMBER(12) NOT NULL,
  VISIT_ID           NUMBER(12) NOT NULL,
  VISIT_NUMBER       VARCHAR(40),
  VISIT_TYPE_ID      NUMBER(12),
  VISIT_TYPE         VARCHAR2(50),
  ADMISSION_DT       DATE,
  DISCHARGE_DT       DATE,
  TEST_TYPE_ID       NUMBER(6) NOT NULL,
  EVENT_ID           NUMBER(12) NOT NULL,
  RESULT_DT          DATE NOT NULL,
  DATA_ELEMENT_ID    VARCHAR2(25) NOT NULL,
  DATA_ELEMENT_NAME  VARCHAR2(120) NOT NULL,
  RESULT_VALUE       VARCHAR2(1023) NOT NULL
) ON COMMIT PRESERVE ROWS;

COMMENT ON TABLE dsrip_tr016_a1c_glucose_rslt IS 'Temporary storage of the A1c and Glucose Level test results - for use in DSRIP report TR016 - "Diabetes screening of people taking Antipsychotic Medications"';
