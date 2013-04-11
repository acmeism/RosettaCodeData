EXTREMES
  NEW INF,NINF,ZERO,NOTNUM,NEGZERO
  SET INF=$DOUBLE(3.0E310),NINF=$DOUBLE(-3.0E310),ZERO=$DOUBLE(0),NOTNUM=$DOUBLE(INF-INF),NEGZERO=$DOUBLE(ZERO*-1)
  WRITE "Infinity: ",INF,!
  WRITE "Infinity ",$SELECT($ISVALIDNUM(INF):"is a number",1:"is not a number"),!
  WRITE "Negative Infinity: ",NINF,!
  WRITE "Negative Infinity ",$SELECT($ISVALIDNUM(NINF):"is a number",1:"is not a number"),!
  WRITE "Zero: ",ZERO,!
  WRITE "Zero ",$SELECT($ISVALIDNUM(ZERO):"is a number",1:"is not a number"),!
  WRITE "Negative Zero: ",NEGZERO,!
  WRITE "Negative Zero ",$SELECT($ISVALIDNUM(NEGZERO):"is a number",1:"is not a number"),!
  WRITE "Not a Number: ",NOTNUM,!
  WRITE "Not a Number ",$SELECT($ISVALIDNUM(NOTNUM):"is a number",1:"is not a number"),!
  KILL INF,NINF,ZERO,NONNUM,NEGZERO
 QUIT
