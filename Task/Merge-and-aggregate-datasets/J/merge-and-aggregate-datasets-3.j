require'csv'
patients=: fixcsv {{)n
PATIENTID,LASTNAME
1001,Hopper
4004,Wirth
3003,Kemeny
2002,Gosling
5005,Kurtz
}}

visits=: fixcsv {{)n
PATIENTID,VISIT_DATE,SCORE
2002,2020-09-10,6.8
1001,2020-09-17,5.5
4004,2020-09-24,8.4
2002,2020-10-08,
1001,,6.6
3003,2020-11-12,
4004,2020-11-05,7.0
1001,2020-11-19,5.3
}}

task=: {{
  P=. <@:>"1|:/:~}.patients
  V=. <@:>"1|:/:~}.visits
  id=. 0 {:: P
  nm=. 1 {:: P
  sel1=. (0 {:: P) e. 0 {:: V
  sel2=. (~.0 {:: V) e. 0 {:: P NB. unnecessary for this example
  exp=. sel1 #inv sel2 # ]
  agg=. /.(&.:".)
  vdt=. exp     (0 {:: V) {:/.         1 {:: V
  sum=. exp ":,.(0 {:: V) +//.     0". 2 {:: V
  avg=. exp ":,.(0 {:: V) (+/%#)/. 0". 2 {:: V
  labels=. ;:'PATIENT_ID LASTNAME LAST_VISIT SCORE_SUM SCORE_AVG'
  labels,:id;nm;vdt;sum;avg
}}
