$$ MODE tuscript
SET nr1=RANDOM_NUMBERS (1,9,1)
LOOP
  SET nr2=RANDOM_NUMBERS (1,9,1)
  IF (nr2!=nr1) EXIT
ENDLOOP
LOOP
  SET nr3=RANDOM_NUMBERS (1,9,1)
  IF (nr3!=nr1,nr2) EXIT
ENDLOOP
LOOP
  SET nr4=RANDOM_NUMBERS (1,9,1)
  IF (nr4!=nr1,nr2,nr3) EXIT
ENDLOOP
SET nr=JOIN(nr1,"'",nr2,nr3,nr4), limit=10
LOOP r=1,limit
SET bulls=cows=0
ASK "round {r} insert a number":guessnr=""
SET length=LENGTH(guessnr), checknr=STRINGS (guessnr,":>/:")
 LOOP n=nr,y=checknr
  IF (length!=4) THEN
   PRINT "4-letter digit required"
   EXIT
  ELSEIF (n==y) THEN
   SET bulls=bulls+1
  ELSEIF (nr.ct.":{y}:") THEN
   SET cows=cows+1
  ENDIF
 ENDLOOP
PRINT "bulls=",bulls," cows=",cows
 IF (bulls==4) THEN
  PRINT "BINGO"
  EXIT
 ELSEIF (r==limit) THEN
  PRINT "BETTER NEXT TIME"
  EXIT
 ENDIF
ENDLOOP
