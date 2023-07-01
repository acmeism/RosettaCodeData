# Read the two tables:
INDEX($patients | [splits("\n")] | map(split(",")) | csv2jsonHelper[]; .PATIENT_ID) as $patients
| ($visits | [splits("\n")] | map(split(",")) | csv2jsonHelper) as $visits
# Construct the new table:
| $visits
| map(.PATIENT_ID as $PATIENT_ID
      | {$PATIENT_ID}  +
        ($visits | {LASTNAME: $patients[$PATIENT_ID|tostring]} + LAST_VISIT($PATIENT_ID) + SCORE_SUMMARY($PATIENT_ID)))
# ... but display it as a sequence of JSON objects
| .[]
