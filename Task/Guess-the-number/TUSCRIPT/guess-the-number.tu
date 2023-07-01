$$ MODE TUSCRIPT
PRINT "Find the luckynumber (7 tries)!"
luckynumber=RANDOM_NUMBERS (1,10,1)
COMPILE
LOOP round=1,7
message=CONCAT ("[",round,"] Please insert a number")
ASK $message: n=""
 IF (n!='digits') THEN
   PRINT "wrong insert: ",n," Please insert a digit"
 ELSEIF (n>10.or.n<1) THEN
   PRINT "wrong insert: ",n," Please insert a number between 1-10"
 ELSEIF (n==#luckynumber) THEN
   PRINT "BINGO"
   EXIT
ENDIF
IF (round==7) PRINT/ERROR "You've lost: luckynumber was: ",luckynumber
ENDLOOP
ENDCOMPILE
