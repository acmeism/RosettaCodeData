-module(permute).
-export([permute/1]).

permute(L) -> permute(L,length(L)).
permute([],_) -> [[]];
permute(_,0) -> [[]];
permute(L,I) -> [[X|Y] || X<-L, Y<-permute(L,I-1)].
