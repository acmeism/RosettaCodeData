task=: {{
  P=. <@:>"1|:/:~}.patients
  V=. <@:>"1|:/:~}.visits
  id=. 0 {:: P
  nm=. 1 {:: P
  sel1=. (0 {:: P) e. 0 {:: V
  sel2=. (~.0 {:: V) e. 0 {:: P NB. unnecessary for this example
  exp=. sel1 #inv sel2 # ]
  agg=. /.(&.:".)
  vdt=. exp     (0 {:: V) {:/.          1 {:: V
  sel3=. (0 {:: V) +.//. 2 *@#@{::"1 }.visits
  exp2=: [:exp sel3 #inv sel3 #]
  sum=. exp2 ":,.(0 {:: V) +//.     0". 2 {:: V
  avg=. exp2 ":,.(0 {:: V) (+/%#)/. 0". 2 {:: V
  labels=. ;:'PATIENT_ID LASTNAME LAST_VISIT SCORE_SUM SCORE_AVG'
  labels,:id;nm;vdt;sum;avg
}}
