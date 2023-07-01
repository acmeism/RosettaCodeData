$$ MODE TUSCRIPT
numbers=""
LOOP n=1,10
numbers=APPEND (numbers,", ",n)
rest=n%5
IF (rest!=0) CYCLE
 PRINT numbers
 numbers=""
ENDLOOP
