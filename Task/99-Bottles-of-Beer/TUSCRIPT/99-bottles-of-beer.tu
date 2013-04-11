$$ MODE TUSCRIPT
LOOP bottle=1,100
SET bottlenr=100-bottle
IF (bottlenr==0) THEN
PRINT "no bottle of beer on the wall"
EXIT
ELSEIF (bottlenr==1) THEN
PRINT bottlenr, " bottle of beer on the wall"
PRINT bottlenr, " bottle of beer"
ELSE
PRINT bottlenr, " bottles of beer on the wall"
PRINT bottlenr, " bottles of beer"
ENDIF
PRINT "Take one down, pass it around"
ENDLOOP
