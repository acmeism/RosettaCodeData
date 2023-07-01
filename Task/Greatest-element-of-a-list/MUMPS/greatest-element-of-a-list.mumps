MV(A,U)
 ;A is a list of values separated by the string U
 NEW MAX,T,I
 FOR I=1:1 SET T=$PIECE(A,U,I) QUIT:T=""  S MAX=$SELECT(($DATA(MAX)=0):T,(MAX<T):T,(MAX>=T):MAX)
 QUIT MAX
