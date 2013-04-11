$$ MODE TUSCRIPT
ASK "insert number1", nr1=""
ASK "insert number2", nr2=""

SET nrs=APPEND(nr1,nr2),size_nrs=SIZE(nrs)
IF (size_nrs!=2) ERROR/STOP "insert two numbers"
LOOP n=nrs
IF (n!='digits') ERROR/STOP n, " is not a digit"
ENDLOOP

PRINT "ethopian multiplication of ",nr1," and ",nr2

SET sum=0
SECTION checkifeven
SET even=MOD(nr1,2)
 IF (even==0) THEN
   SET action="struck"
 ELSE
   SET action="kept"
   SET sum=APPEND (sum,nr2)
 ENDIF
SET nr1=CENTER (nr1,+6),nr2=CENTER (nr2,+6),action=CENTER (action,8)
PRINT nr1,nr2,action
ENDSECTION

SECTION halve_i
SET nr1=nr1/2
ENDSECTION

SECTION double_i
nr2=nr2*2
ENDSECTION

DO checkifeven

LOOP
DO halve_i
DO double_i
DO checkifeven
IF (nr1==1) EXIT
ENDLOOP

SET line=REPEAT ("=",20), sum = sum(sum),sum=CENTER (sum,+12)
PRINT line
PRINT sum
