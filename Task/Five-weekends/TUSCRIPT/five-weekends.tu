$$ MODE TUSCRIPT
LOOP year=1900,2100
 LOOP month="1'3'5'7'8'10'12"
 SET dayofweek=DATE (number,1,month,year,nummer)
 IF (dayofweek==5) PRINT year,"-",month
 ENDLOOP
ENDLOOP
