exec dbm.drop_tables('REF_VISIT_TYPES');

CREATE TABLE ref_visit_types
(
  VISIT_TYPE_ID  NUMBER(12) CONSTRAINT pk_visit_types PRIMARY KEY,
  NAME           VARCHAR2(50 BYTE),
  ABBREVIATION   CHAR(2 BYTE)
);

ALTER TABLE ref_visit_types ADD CONSTRAINT uk_visit_type UNIQUE(abbreviation);

GRANT SELECT ON ref_visit_types TO PUBLIC;
