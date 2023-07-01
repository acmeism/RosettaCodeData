RPTSTR(S,N)
 ;Repeat a string S for N times
 NEW I
 FOR I=1:1:N WRITE S
 KILL I
 QUIT
RPTSTR1(S,N) ;Functionally equivalent, but denser to read
 F I=1:1:N W S
 Q
