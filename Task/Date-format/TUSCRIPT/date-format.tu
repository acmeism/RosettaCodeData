$$ MODE TUSCRIPT
SET dayofweek = DATE (today,day,month,year,number)

SET months=*
DATA January
DATA Februari
DATA March
DATA April
DATA Mai
DATA June
DATA July
DATA August
DATA September
DATA October
DATA November
DATA December

SET days="Monday'Tuesday'Wendsday'Thursday'Fryday'Saturday'Sonday"

SET nameofday  =SELECT (days,#dayofweek)
SET nameofmonth=SELECT (months,#month)

SET format1=JOIN (year,"-",month,day)
SET format2=CONCAT (nameofday,", ",nameofmonth," ",day, ", ",year)

PRINT format1
PRINT format2
