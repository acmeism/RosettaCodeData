$$ MODE TUSCRIPT
PRINT "25th of December will be a Sunday in the following years: "
LOOP year=2008,2121
SET dayofweek = DATE (number,25,12,year,nummer)
IF (dayofweek==7) PRINT year
ENDLOOP
