$$ MODE TUSCRIPT
x=y="1'2'3'4'5'6'7'8'9'10'11'12"
LOOP n,col=x,cnt=""
 skip=n-1
 LOOP m,row=y
  IF (m==skip) THEN
   td=""
  ELSE
   td=col*row
   coleqrow=col*n
   IF (td.lt.#coleqrow) td=""
  ENDIF
 td=CENTER (td,+3," ")
 cnt=APPEND (cnt,td," ")
 ENDLOOP
 col=CENTER (col,+3," ")
 PRINT col,cnt
ENDLOOP
