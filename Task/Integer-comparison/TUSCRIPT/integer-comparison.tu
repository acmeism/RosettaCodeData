$$ MODE TUSCRIPT

ASK "Please enter your first integer:": i1=""
ASK "Please enter your second integer:": i2=""

IF (i1!='digits'||i2!='digits') ERROR/STOP "Please insert digits"

IF (i1==i2) PRINT i1," is equal to     ",i2
IF (i1<i2)  PRINT i1," is less than    ",i2
IF (i1>i2)  PRINT i1," is greater than ",i2
