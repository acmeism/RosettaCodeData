$$ MODE DATA
$$ csv=*
C1,C2,C3,C4,C5
1,5,9,13,17
2,6,10,14,18
3,7,11,15,19
4,8,12,16,20
$$ MODE TUSCRIPT
LOOP/CLEAR n,line=csv
 IF (n==1) THEN
  line=CONCAT (line,",SUM")
 ELSE
  lineadd=EXCHANGE(line,":,:':")
  sum=SUM(lineadd)
  line=JOIN(line,",",sum)
 ENDIF
 csv=APPEND(csv,line)
ENDLOOP
