$$ MODE TUSCRIPT
PRINT "Find the luckynumber (7 tries)!"
SET luckynumber=RANDOM NUMBERS (1,100,1)
LOOP round=1,7
SET message=CONCAT ("[",round,"] Please insert a number")
ASK $message: n=""
 IF (n!='digits') THEN
   PRINT "wrong insert: ",n," Please insert a digit"
 ELSEIF (n>100.or.n<1) THEN
   PRINT "wrong insert: ",n," Please insert a number between 1-100"
 ELSEIF (n==#luckynumber) THEN
   PRINT "BINGO"
   EXIT
 ELSEIF (n.gt.#luckynumber) THEN
   PRINT "too big"
 ELSEIF (n.lt.#luckynumber) THEN
   PRINT "too small"
ENDIF
IF (round==7) PRINT/ERROR "You've lost: luckynumber was: ",luckynumber
ENDLOOP
