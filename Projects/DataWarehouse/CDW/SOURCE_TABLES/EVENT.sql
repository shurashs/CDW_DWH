CREATE TABLE event
(
  NETWORK                   CHAR(3 BYTE),
  VISIT_ID                  NUMBER(12) NOT NULL,
  EVENT_ID                  NUMBER(15) NOT NULL,
  DATE_TIME                 DATE,
  EVENT_STATUS_ID           NUMBER(12),
  EVENT_TYPE_ID             NUMBER(12),
  PATIENT_SCHEDULE_DISPLAY  VARCHAR2(100 BYTE),
  CID                       NUMBER(14),
  EVENT_INTERFACE_ID        VARCHAR2(128 BYTE)
)
COMPRESS BASIC
PARTITION BY LIST(network)
SUBPARTITION BY HASH(visit_id) SUBPARTITIONS 16
(
  PARTITION cbn VALUES('CBN'),
  PARTITION gp1 VALUES('GP1'),
  PARTITION gp2 VALUES('GP2'),
  PARTITION nbn VALUES('NBN'),
  PARTITION nbx VALUES('NBX'),
  PARTITION qhn VALUES('QHN'),
  PARTITION sbn VALUES('SBN'),
  PARTITION smn VALUES('SMN')
);

CREATE UNIQUE INDEX pk_event ON event(event_id, visit_id, network) LOCAL PARALLEL 32;
ALTER INDEX pk_event NOPARALLEL;

CREATE INDEX idx_event_cid ON event(cid, network) LOCAL PARALLEL 32;;
ALTER INDEX idx_event_cid NOPARALLEL;

GRANT SELECT ON EVENT_GP1 TO PUBLIC;