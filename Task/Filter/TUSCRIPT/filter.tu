$$ MODE TUSCRIPT
arr="1'4'9'16'25'36'49'64'81'100",even=""
LOOP nr=arr
rest=MOD (nr,2)
IF (rest==0) even=APPEND (even,nr)
ENDLOOP
PRINT even
