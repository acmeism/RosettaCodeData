$$ MODE TUSCRIPT
LOOP n,list="2'4'0'3'1'2'-12"
IF (n==1)          greatest=VALUE(list)
IF (list>greatest) greatest=VALUE(list)
ENDLOOP
PRINT greatest
