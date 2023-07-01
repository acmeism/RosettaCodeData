require'jd'

echo jd {{)n
  reads
        PATIENT_ID: first p.PATIENTID,
        LASTNAME:   first p.LASTNAME,
        LAST_VISIT: max v.VISIT_DATE,
        SCORE_SUM:  sum v.SCORE,
        SCORE_AVG:  avg v.SCORE
    by
      p.PATIENTID
    from
      p:patients,
      v:p.visits
}} -.LF
