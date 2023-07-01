$$ MODE TUSCRIPT
MODE DATA
$$ SET cardnumbers=*
49927398716
49927398717
1234567812345678
1234567812345670
$$ MODE TUSCRIPT
-> collecting information for output-format
SET length=MAX_LENGTH(cardnumbers)
SET adjust=length+2

LOOP c=cardnumbers
-> ">/" = any digit
SET cstring=STRINGS (c,":>/:")
SET creverse=REVERSE (cstring)
SET s1=evenx2=esum=s2=""
 LOOP n,oe=creverse
  SET modrest=MOD(n,2)
  IF (modrest==0) THEN
   SET even=oe*2
    IF (even>9) THEN
     SET estring=STRINGS (even,":>/:")
     SET esum=SUM (estring)
     SET s2=APPEND (s2,esum)
    ELSE
     SET s2=APPEND (s2,even)
    ENDIF
  ELSE
   SET s1=APPEND(s1,oe)
  ENDIF
 ENDLOOP
SET s1=SUM(s1),s2=SUM(s2)
SET checksum=s1+s2
SET c=CENTER(c,-adjust)
IF (checksum.ew."0") THEN
 PRINT c,"true"
ELSE
 PRINT c,"false"
ENDIF
ENDLOOP
