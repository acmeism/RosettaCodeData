comb_Prolog(L, M, N) :-
    length(L, M),
    fill(L, 1, N).

fill([], _, _).

fill([H | T], Min, Max) :-
    between(Min, Max, H),
    H1 is H + 1,
    fill(T, H1, Max).
