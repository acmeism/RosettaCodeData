$$ MODE TUSCRIPT
list_old="b'A'A'5'1'2'3'2'3'4"
DICT list CREATE
LOOP l=list_old
DICT list LOOKUP l,num
IF (num==0) DICT list ADD l
ENDLOOP
DICT list unload list
list_new=JOIN (list)
PRINT list_old
PRINT list_new
