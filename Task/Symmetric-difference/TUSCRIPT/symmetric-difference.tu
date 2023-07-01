$$ MODE TUSCRIPT
a="John'Bob'Mary'Serena"
b="Jim'Mary'John'Bob"

DICT names CREATE

SUBMACRO checknames
!var,val
PRINT val,": ",var
 LOOP n=var
  DICT names APPEND/QUIET n,num,cnt,val;" "
 ENDLOOP
ENDSUBMACRO

CALL checknames (a,"a")
CALL checknames (b,"b")

DICT names UNLOAD names,num,cnt,val

LOOP n=names,v=val
PRINT n," in: ",v
ENDLOOP
