$$ MODE TUSCRIPT
set1="the'that'a"
set2="frog'elephant'thing"
set3="walked'treaded'grows"
set4="slowly'quickly"
LOOP w1=set1
 lastw1=EXTRACT (w1,-1,0)
 LOOP w2=set2
 IF (w2.sw.$lastw1) THEN
  lastw2=EXTRACT (w2,-1,0)
  LOOP w3=set3
  IF (w3.sw.$lastw2) THEN
   lastw3=EXTRACT (w3,-1,0)
   LOOP w4=set4
   IF (w4.sw.$lastw3) sentence=JOIN (w1," ",w2,w3,w4)
   ENDLOOP
  ENDIF
  ENDLOOP
 ENDIF
 ENDLOOP
ENDLOOP
PRINT sentence
