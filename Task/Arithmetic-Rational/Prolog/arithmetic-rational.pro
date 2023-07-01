divisor(N, Div) :-
    Max is floor(sqrt(N)),
    between(1, Max, D),
    divmod(N, D, _, 0),
    (Div = D; Div is N div D, Div =\= D).

divisors(N, Divs) :-
    setof(M, divisor(N, M), Divs).

recip(A, B) :- B is 1 rdiv A.

sumrecip(N, A) :-
    divisors(N, [1 | Ds]),
    maplist(recip, Ds, As),
    sum_list(As, A).

perfect(X) :- sumrecip(X, 1).

main :-
    Limit is 1 << 19,
    forall(
        (between(1, Limit, N), perfect(N)),
	(format("~w~n", [N]))),
    halt.

?- main.
