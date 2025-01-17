CREATE OR REPLACE VIEW v_tr001_detail_cdw AS
SELECT
  last_name,
  first_name,
  dob,
  streetadr, apt_suite, city, state, zipcode, country, home_phone, day_phone,
  prim_care_provider,	 
  hospitalization_facility,	 
  mrn,
  admission_dt,	 
  discharge_dt, 
  follow_up_visit_id,	 
  follow_up_facility,
  follow_up_visit_number,	 
  follow_up_dt,
  bh_provider_info,
  payer,
  payer_group,	 
  fin_class,
  follow_up_30_days,	 
  follow_up_7_days	 
FROM dsrip_report_tr001_qmed rpt
WHERE report_period_start_dt = NVL(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'), (SELECT MAX(report_period_start_dt) FROM dsrip_report_tr001_qmed)) 
ORDER BY discharge_dt, last_name, first_name;
