$$ MODE TUSCRIPT
year=2012
LOOP month=1,12
 LOOP day=31,22,-1
  dayofweek=DATE (number,day,month,year,nummer)
  IF (dayofweek==5) THEN
  PRINT year,"-",month,"-",day
  EXIT
  ENDIF
 ENDLOOP
ENDLOOP
