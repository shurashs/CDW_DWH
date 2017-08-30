CREATE OR REPLACE VIEW vw_edd_stats AS
SELECT
 -- 08-Jun-2017, OK: created
 -- 26-JUN-2017, OK: used CLIENT_IDENTIFIER
  TRUNC(arrival_dt) AS visit_start_dt,
  facility_key,
  esi_key,
  patient_age_group_id,
  patient_gender_cd,
  disposition_key,
  progress_ind,
  COUNT(1) num_of_visits,
  SUM(arrival_to_triage) arrival_to_triage,
  SUM(arrival_to_first_provider) arrival_to_first_provider,
  SUM(arrival_to_disposition) arrival_to_disposition,
  SUM(arrival_to_exit) arrival_to_exit,
  SUM(triage_to_first_provider) triage_to_first_provider,
  SUM(triage_to_disposition) triage_to_disposition,
  SUM(triage_to_exit) triage_to_exit,
  SUM(first_provider_to_disposition) first_provider_to_disposition,
  SUM(first_provider_to_exit) first_provider_to_exit,
  SUM(disposition_to_exit) disposition_to_exit,
  SUM(dwell) dwell   
FROM edd_fact_visits
WHERE arrival_dt >= TO_DATE(SYS_CONTEXT('USERENV','CLIENT_IDENTIFIER'))  
GROUP BY TRUNC(arrival_dt), facility_key, esi_key, patient_age_group_id, patient_gender_cd, disposition_key, progress_ind;

GRANT SELECT ON vw_edd_stats TO PUBLIC;