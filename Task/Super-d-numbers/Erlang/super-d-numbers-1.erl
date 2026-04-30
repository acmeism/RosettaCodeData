-module(superD).
-export([superD/2]).
pow(_,0,A)->A;
pow(N,G,A)->pow(N,G-1,A*N).
pow(N,G)->pow(N,G-1,N).
fL(E,N,_) when E>N->false;
fL(E,N,I) when (E-(N rem I))==0->true;
fL(E,N,I)->fL(E,N div 10,I).
superD(N,C)->I=pow(10,N),superD(N*(111111111 rem I),N,I,1,[],C).
superD(_,_,_,_,A,0)->A;
superD(E,N,I,Z,A,C)->case fL(E,N*pow(Z,N),I) of true->superD(E,N,I,Z+1,[Z|A],C-1); false->superD(E,N,I,Z+1,A,C) end.
