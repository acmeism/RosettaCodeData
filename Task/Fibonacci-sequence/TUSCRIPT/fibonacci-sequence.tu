$$ MODE TUSCRIPT
ASK "What fibionacci number do you want?": searchfib=""
IF (searchfib!='digits') STOP
Loop n=0,{searchfib}
 IF (n==0) THEN
   fib=fiba=n
 ELSEIF (n==1) THEN
   fib=fibb=n
 ELSE
   fib=fiba+fibb, fiba=fibb, fibb=fib
 ENDIF
 IF (n!=searchfib) CYCLE
 PRINT "fibionacci number ",n,"=",fib
ENDLOOP
