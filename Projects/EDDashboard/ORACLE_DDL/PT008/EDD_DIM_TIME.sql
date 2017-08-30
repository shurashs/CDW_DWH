exec dbm.drop_tables('EDD_DIM_TIME');

CREATE TABLE edd_dim_time
(
  DimTimeKey NUMBER(10,0) CONSTRAINT PK_Time PRIMARY KEY,
  Date_ DATE NOT NULL CONSTRAINT UK_Time UNIQUE,
  Time VARCHAR2(50 CHAR),
  Time24 VARCHAR2(50 CHAR),
  Hour NUMBER(3,0),
  HourName VARCHAR2(10 CHAR),
  Minute NUMBER(3,0),
  MinuteKey NUMBER(10,0),
  MinuteName VARCHAR2(20 CHAR),
  Hour24 NUMBER(3,0),
  AM CHAR(2 CHAR),
  Year NVARCHAR2(30),
  Quarter NVARCHAR2(30),
  ShortQuarter NVARCHAR2(10),
  Month NVARCHAR2(30),
  ShortMonth NVARCHAR2(30),
  MonthSort NUMBER(10,0),
  DateHour DATE,
  Day VARCHAR2(30 CHAR),
  ShortDay NVARCHAR2(10),
  WeekSort NUMBER(10,0),
  DayOfWeek VARCHAR2(10 CHAR),
  ShortDOW NVARCHAR2(30),
  DaySort NUMBER(10,0)
) COMPRESS BASIC;

COMMENT ON COLUMN edd_dim_time.date_ IS 'ORIGINAL NAME:Date';

GRANT SELECT ON edd_dim_time TO PUBLIC;
