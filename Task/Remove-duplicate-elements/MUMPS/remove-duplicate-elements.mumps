REMDUPE(L,S)
 ;L is the input listing
 ;S is the separator between entries
 ;R is the list to be returned
 NEW Z,I,R
 FOR I=1:1:$LENGTH(L,S) SET Z($PIECE(L,S,I))=""
 ;Repack for return
 SET I="",R=""
 FOR  SET I=$O(Z(I)) QUIT:I=""  SET R=$SELECT($L(R)=0:I,1:R_S_I)
 KILL Z,I
 QUIT R
