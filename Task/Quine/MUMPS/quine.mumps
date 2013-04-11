QUINE
 NEW I,L SET I=0
 FOR  SET I=I+1,L=$TEXT(+I) Q:L=""  WRITE $TEXT(+I),!
 KILL I,L
 QUIT

SMALL
 S %=0 F  W $T(+$I(%)),! Q:$T(+%)=""
