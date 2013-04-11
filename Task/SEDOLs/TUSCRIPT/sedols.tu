$$ MODE TUSCRIPT
check="1'3'1'7'3'9"
values="123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
value=STRINGS (values,":<%:")
BUILD r_TABLE/or illegal=":A:E:I:O:U:"
LOOP input="710889'B0YBKJ'406566'B0YBLH'228276'B0YBKL'557910'B0YBKR'585284'B0YBKT'BOYAKT'B00030",sum=""
  IF (input.ma.illegal) THEN
   PRINT/ERROR input, " illegal"
   CYCLE
  ENDIF
  strings=STRINGS (input,":<%:")
  LOOP d,nr=strings
   c=SELECT (check,#d)
   IF (nr!='digits') nr=FILTER_INDEX (value,":{nr}:",-)
   x=nr*c, sum=APPEND(sum,x)
  ENDLOOP
  endsum=SUM(sum), checksum=10-(endsum%10)
  IF (checksum==10) checksum=0
  PRINT input, " checkdigit: ", checksum
ENDLOOP
