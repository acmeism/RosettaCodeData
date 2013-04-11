$$ MODE TUSCRIPT
DICT doors create
COMPILE
LOOP door=1,100
 LOOP pass=1,100
 SET go=MOD (door,pass)
 DICT doors lookup door,num,cnt,status
   IF (num==0) THEN
     SET status="open"
     DICT doors add  door,num,cnt,status
   ELSE
    IF (go==0) THEN
       IF (status=="closed") THEN
         SET status="open"
       ELSE
         SET status="closed"
       ENDIF
     DICT doors update door,num,cnt,status
     ENDIF
   ENDIF
 ENDLOOP
ENDLOOP
ENDCOMPILE
DICT doors unload door,num,cnt,status
