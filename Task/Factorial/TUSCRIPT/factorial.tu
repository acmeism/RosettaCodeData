$$ MODE TUSCRIPT
LOOP num=-1,12
 IF (num==0,1) THEN
  f=1
 ELSEIF (num<0) THEN
  PRINT num," is negative number"
  CYCLE
 ELSE
  f=VALUE(num)
  LOOP n=#num,2,-1
   f=f*(n-1)
  ENDLOOP
 ENDIF
formatnum=CENTER(num,+2," ")
PRINT "factorial of ",formatnum," = ",f
ENDLOOP
