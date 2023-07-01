$$ MODE TUSCRIPT
LOOP
ASK "Enter a string": str=""
ASK "Enter an integer": int=""
IF (int=='digits') THEN
PRINT "int=",int," str=",str
EXIT
ELSE
PRINT/ERROR int," is not an integer"
CYCLE
ENDIF
ENDLOOP
