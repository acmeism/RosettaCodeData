product([A|_], Bs, [A, B]) :- member(B, Bs).
product([_|As], Bs, X) :- product(As, Bs, X).
