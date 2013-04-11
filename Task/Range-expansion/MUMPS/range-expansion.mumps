RANGEXP(X) ;Integer range expansion
 NEW Y,I,J,X1,H SET Y=""
 FOR I=1:1:$LENGTH(X,",") DO
 .S X1=$PIECE(X,",",I) FOR  Q:$EXTRACT(X1)'=" "  S X1=$EXTRACT(X1,2,$LENGTH(X1)) ;clean up leading spaces
 .SET H=$FIND(X1,"-")-1
 .IF H=1 SET H=$FIND(X1,"-",(H+1))-1 ;If the first value is negative ignore that "-"
 .IF H<0 SET Y=$SELECT($LENGTH(Y)=0:Y_X1,1:Y_","_X1)
 .IF '(H<0) FOR J=+$EXTRACT(X1,1,(H-1)):1:+$EXTRACT(X1,(H+1),$LENGTH(X1)) SET Y=$SELECT($LENGTH(Y)=0:J,1:Y_","_J)
 KILL I,J,X1,H
 QUIT Y
