% reduce() prints the intermediate results so that one can see Prolog "thinking."
%
reduce(A, C) :-
    simplify(A, B),
    (B = A -> C = A; io:format("= ~w~n", [B]), reduce(B, C)).

simplify(exp(i*X), cos(X) + i*sin(X)) :- !.

simplify(0 + A, A) :- !.
simplify(A + 0, A) :- !.
simplify(A + B, C) :-
    integer(A),
    integer(B), !,
    C is A + B.
simplify(A + B, C + D) :- !,
    simplify(A, C),
    simplify(B, D).

simplify(0 * _, 0) :- !.
simplify(_ * 0, 0) :- !.
simplify(1 * A, A) :- !.
simplify(A * 1, A) :- !.
simplify(A * B, C) :-
    integer(A),
    integer(B), !,
    C is A * B.
simplify(A * B, C * D) :- !,
    simplify(A, C),
    simplify(B, D).

simplify(cos(0),  1)  :- !.
simplify(sin(0),  0)  :- !.
simplify(cos(pi), -1) :- !.
simplify(sin(pi), 0)  :- !.

simplify(X, X).
