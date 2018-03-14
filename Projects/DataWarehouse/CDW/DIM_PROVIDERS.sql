exec dbm.drop_tables('DIM_PROVIDERS');

CREATE TABLE dim_providers
(
  NETWORK                   CHAR(3 BYTE) NOT NULL,
  PROVIDER_KEY              NUMBER(12) NOT NULL,
  PROVIDER_ID               NUMBER(12) NOT NULL,
  ARCHIVE_NUMBER            NUMBER(12) NOT NULL,
  PROVIDER_NAME             VARCHAR2(60 BYTE) NOT NULL,
  TITLE_ID                  NUMBER(12),
  TITLE_NAME                VARCHAR2(100 BYTE),
  TITLE_PREFIX              VARCHAR2(20 BYTE),
  TITLE_SUFFIX              VARCHAR2(50 BYTE),
  PHYSICIAN_FLAG            VARCHAR2(5 BYTE),
  EMP                       VARCHAR2(2048 BYTE),
  LICENSE                   VARCHAR2(2048 BYTE),
  SOCIAL_SECURITY           VARCHAR2(2048 BYTE),
  SDG_EMP_NO                VARCHAR2(2048 BYTE),
  PRAC_NPI                  VARCHAR2(2048 BYTE),
  NPI                       VARCHAR2(2048 BYTE),
  LICENSE_EXP_DATE_ID       VARCHAR2(2048 BYTE),
  PHYSICIAN_SERVICE_ID      VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_NAME    VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_ID_1    VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_NAME_1  VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_ID_2    VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_NAME_2  VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_ID_3    VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_NAME_3  VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_ID_4    VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_NAME_4  VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_ID_5    VARCHAR2(4000 BYTE),
  PHYSICIAN_SERVICE_NAME_5  VARCHAR2(4000 BYTE),
  SOURCE                    CHAR(4 BYTE) DEFAULT 'QCPR' NOT NULL,
  EFFECTIVE_FROM            DATE DEFAULT DATE '1901-01-01',
  EFFECTIVE_TO              DATE DEFAULT DATE '9999-12-31',
  CURRENT_FLAG              NUMBER(1) DEFAULT 1 NOT NULL CONSTRAINT chk_provider_curr_flag CHECK (current_flag IN (0,1)),
  LOAD_DT                   DATE DEFAULT SYSDATE
)
COMPRESS BASIC 
PARTITION BY LIST (NETWORK)
(  
  PARTITION CBN VALUES ('CBN'),
  PARTITION GP1 VALUES ('GP1'),
  PARTITION GP2 VALUES ('GP2'),
  PARTITION NBN VALUES ('NBN'),
  PARTITION NBX VALUES ('NBX'),
  PARTITION QHN VALUES ('QHN'),
  PARTITION SBN VALUES ('SBN'),
  PARTITION SMN VALUES ('SMN')
);

CREATE UNIQUE INDEX pk_dim_providers1 ON dim_providers(provider_key) PARALLEL 32;
ALTER INDEX pk_dim_providers1 NOPARALLEL;

CREATE UNIQUE INDEX UK1_DIM_PROVIDERS1 ON DIM_PROVIDERS(provider_id, archive_number, network) LOCAL PARALLEL 32;
ALTER INDEX UK1_DIM_PROVIDERS1 NOPARALLEL;

CREATE UNIQUE INDEX UK2_DIM_PROVIDERS1 ON DIM_PROVIDERS(CASE CURRENT_FLAG WHEN 1 THEN NETWORK END, CASE CURRENT_FLAG WHEN 1 THEN PROVIDER_ID END) PARALLEL 32;
ALTER INDEX UK2_DIM_PROVIDERS1 NOPARALLEL;

ALTER  TABLE dim_providers ADD
(
  CONSTRAINT pk_dim_providers1 PRIMARY KEY(provider_key) USING INDEX pk_dim_providers1,
  CONSTRAINT uk1_dim_providers1 UNIQUE(provider_id, archive_number, network) USING INDEX uk1_dim_providers1
);

GRANT SELECT ON DIM_PROVIDERS TO PUBLIC;
