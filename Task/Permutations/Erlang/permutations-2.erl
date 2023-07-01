F = fun(L) -> G = fun(_, []) -> [[]]; (F, L) -> [[X|Y] || X<-L, Y<-F(F, L--[X])] end, G(G, L) end.
