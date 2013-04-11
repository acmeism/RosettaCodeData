XOR(Y,Z) ;Uses logicals - i.e., 0 is false, anything else is true (1 is used if setting a value)
 QUIT (Y&'Z)!('Y&Z)
HALF(W,X)
 QUIT $$XOR(W,X)_"^"_(W&X)
FULL(U,V,CF)
 NEW F1,F2
 S F1=$$HALF(U,V)
 S F2=$$HALF($P(F1,"^",1),CF)
 QUIT $P(F2,"^",1)_"^"_($P(F1,"^",2)!($P(F2,"^",2)))
FOUR(Y,Z,C4)
 NEW S,I,T
 FOR I=4:-1:1 SET T=$$FULL($E(Y,I),$E(Z,I),C4),$E(S,I)=$P(T,"^",1),C4=$P(T,"^",2)
 K I,T
 QUIT S_"^"_C4
