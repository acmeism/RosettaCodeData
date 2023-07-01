% Calculate the value e = exp 1
%   Use Newton's method: x0 = 2; y = x(2 - ln x)

tolerance(1e-15).

exp1_iter(L) :-
    lazy_list(newton, 2, L).

newton(X0, X1, X1) :-
    X1 is X0*(2 - log(X0)).

e([X1, X2|_], X1) :- tolerance(Eps), abs(X2 - X1) < Eps.
e([_|Xs], E) :- e(Xs, E).

main :-
    exp1_iter(Iter),
    e(Iter, E),
    format("e = ~w~n", [E]),
    halt.

?- main.
