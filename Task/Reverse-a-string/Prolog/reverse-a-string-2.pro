accRev([H|T], A, R) :- accRev(T, [H|A], R).
accRev([], A, A).

rev(L,R) :- accRev(L,[],R).
