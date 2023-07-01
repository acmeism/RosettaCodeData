OUTER
 SET OUT=1,IN=0
 WRITE "OUT = ",OUT,!
 WRITE "IN = ",IN,!
 DO INNER
 WRITE:$DATA(OUT)=0 "OUT was destroyed",!
 QUIT
INNER
 WRITE "OUT (inner scope) = ",OUT,!
 WRITE "IN (outer scope) = ",IN,!
 NEW IN
 SET IN=3.14
 WRITE "IN (inner scope) = ",IN,!
 KILL OUT
 QUIT
