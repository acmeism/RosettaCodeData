   s1=: ambsel;:'the that a'
   s2=: ambsel;:'frog elephant thing'
   s3=: ambsel;:'walked treaded grows'
   s4=: ambsel;:'slowly quickly'
   edgematch=: {{ x,y assert. ({:;x)={.;y }}
   {{)n  edgematch/ s1,s2,s3,s4  }} ambassert
   echo s1,s2,s3,s4
┌────┬─────┬─────┬──────┐
│that│thing│grows│slowly│
└────┴─────┴─────┴──────┘
