CREATE OR REPLACE VIEW v_fact_visit_segment_locations AS
 SELECT
  s.network,
  s.visit_id,
  s.visit_segment_number,
 nvl( l.location_id,'N/A') location_id,
  s.activation_time,
  s.visit_number,
  s.visit_type_id,
  s.visit_subtype_id,
  s.financial_class_id,
  s.admitting_emp_provider_id,
  s.diagnosis,
  s.visit_service_type_id,
  s.facility_id,
  s.arrival_mode_id,
  s.arrival_mode_string,
  s.admit_event_id,
  s.last_edit_time,
  s.invalid_conversion_flag,
  s.accident_on_job,
  s.cid AS visit_seg_cid
 FROM
  visit_segment s
  LEFT JOIN visit_segment_visit_location l
   ON l.network = s.network AND l.visit_id = s.visit_id AND l.visit_segment_number = s.visit_segment_number