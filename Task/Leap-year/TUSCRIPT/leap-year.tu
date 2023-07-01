$$ MODE TUSCRIPT
LOOP year="1900'1994'1996'1997'2000",txt=""
SET dayoftheweek=DATE(number,29,2,year,number)
IF (dayoftheweek==0) SET txt="not "
PRINT year," is ",txt,"a leap year"
ENDLOOP
