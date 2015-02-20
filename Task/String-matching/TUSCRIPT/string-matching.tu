$$ MODE TUSCRIPT
ASK "string1", string1=""
ASK "string2", string2=""

IF (string1.sw.string2)   THEN
PRINT string1," starts with     ",string2
ELSE
PRINT string1," not starts with ",string2
ENDIF
SET beg=STRING (string1,string2,0,0,0,end)
IF (beg!=0) THEN
PRINT string1," contains        ",string2
PRINT "  starting in position ",beg
PRINT "  ending   in position ",end
ELSE
PRINT string1," not contains    ",string2
ENDIF

IF (string1.ew.string2) THEN
PRINT string1," ends with       ",string2
ELSE
PRINT string1," not ends with   ",string2
ENDIF
