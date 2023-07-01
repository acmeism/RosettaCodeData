# output {LAST_VISIT}
def LAST_VISIT($patient_id):
  {LAST_VISIT: (map(select( .PATIENT_ID == $patient_id).VISIT_DATE) | max)};

# output {SCORE_SUM, SCORE_AVG}
def SCORE_SUMMARY($patient_id):
  map(select( .PATIENT_ID == $patient_id).SCORE)
  | {SCORE_SUM: add, count: length}
  | {SCORE_SUM, SCORE_AVG: (if .SCORE_SUM and .count > 0 then .SCORE_SUM/.count else null end)};
