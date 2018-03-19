CREATE OR REPLACE VIEW v_fact_patient_prescriptions AS
SELECT
  -- 14-Mar-2018, SG: change
  -- 08-Mar-2018, SG: created
  d.network,
  NVL(f.facility_key, 9999999999) AS facility_key,
  p.patient_key,
  d.patient_id,
  d.medical_record_number AS mrn,
  NVL(d.order_time, DATE '2010-01-01') AS order_dt,
  TO_NUMBER(TO_CHAR(NVL(d.order_time, DATE '2010-01-01'), 'YYYYMMDD')) AS order_dtnum,
  NVL(LOWER(d.procedure_name), 'n/a') AS drug_name,
  NVL(LOWER(d.derived_product_name), 'n/a') AS drug_description,
  d.rx_quantity,
  d.dosage,
  d.frequency,
  d.rx_dc_time AS rx_dc_dt,
  d.rx_exp_date AS rx_exp_dt
FROM dim_patients p
JOIN pt008.prescription_detail d
  ON d.network = p.network
 AND d.patient_id = p.patient_id
 AND p.effective_from <= NVL(d.order_time, DATE '2010-01-01')
LEFT JOIN dim_hc_facilities f ON f.network = d.network AND f.facility_id = d.facility_id;