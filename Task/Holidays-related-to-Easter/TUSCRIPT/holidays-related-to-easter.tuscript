$$ MODE TUSCRIPT
SET years=*
LOOP period1=400,2100,100
SET years=APPEND(years,period1)
ENDLOOP
LOOP period2=2010,2020
SET years=APPEND(years,period2)
ENDLOOP
SET years=DIGIT SORT (years)
LOOP year=years
SET dayofweek=DATE (EASTER,day,month,year,nreaster)
PRINT "   Easter: ",year," ",month," ",day
 LOOP nr="39'49'56'60",feast="Ascension'Pentecost'  Trinity'   Corpus"
 SET number=nreaster+nr
 SET dayofweek= DATE (DATE,day,month,year,number)
 PRINT feast,": ",year," ",month," ",day
 ENDLOOP
ENDLOOP
