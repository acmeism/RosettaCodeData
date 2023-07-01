main :- task1(8), nl, task2(50), halt.

task1(N) :-
    pascal(Z),
    length(Rows, N),
    prefix(Rows, Z),
    forall(member(Row, Rows),
        (length(Row, K), succ(DecK, K),
        binomial(x, -1, Row, Expr),
        format("(x-1)**~w = ~w~n", [DecK, Expr]))).

task2(Upto) :-
    primes_upto(Upto, Ps),
    format("The primes upto ~w (via AKS) are: ~p~n", [Upto, Ps]).

pascal(Lz) :-
    lazy_list(pascal_row, [], Lz).

pascal_row([], R1, R1) :- R1 = [1], !.
pascal_row(R0, R1, R1) :-
    sum_adj(R0, Next), R1 = [1|Next].

sum_adj(L, L) :- L = [_], !.
sum_adj([A|As], [C|Cs]) :-
    As = [B|_], C is A + B,
    sum_adj(As, Cs).

% First part of task -- create textual representation of (x-1)^n
%  here we generate expression trees
%
binomial(A, B, Coefs, Expr) :-
    length(Coefs, N), succ(DecN, N),
    binomial(B, DecN, A, 0, Coefs, Exp0),
    reduce(Exp0, Exp1),
    addition_to_subtraction(Exp1, Expr).

binomial(_, _, _, _, [], 0) :- !.
binomial(A, PowA, B, PowB, [N|Ns], Ts + T) :-
    T = N * A**PowA * B**PowB,
    IncPow is PowB + 1,
    DecPow is PowA - 1,
    binomial(A, DecPow, B, IncPow, Ns, Ts).

addition_to_subtraction(A + B, X) :-
    addition_to_subtraction(A, C),
    (make_positive(B, D) -> X = C - D; X = C + B), !.
addition_to_subtraction(X, X).

make_positive(N, Term) :- integer(N), N < 0, !, Term is -N.
make_positive(A*B, Term) :-
    make_positive(A, PosA),
    (PosA = 1 -> Term = B, !; Term = PosA*B).

reduce(A, C) :-
    simplify(A, B),
    (B = A -> C = A; reduce(B, C)).

simplify(_**0, 1) :- !.
simplify(1**_, 1) :- !.
simplify(-1**N, Z) :- integer(N), (0 is N /\ 1 -> Z = 1; Z = -1), !.
simplify(X**1, X) :- !.

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

simplify(X, X).

% Second part of task -- Use the coefficients of Pascal's Triangle to check primality.
%

primerow([1, N| Rest]) :- primerow(N, Rest).

primerow(_, End) :- (End = []; End = [1]), !.
primerow(_, [A,A|_]) :- !.  % end when we've seen half the list.
primerow(N, [A|As]) :- A mod N =:= 0, primerow(N, As).

second([_,N|_], N).

primes_upto(N, Ps) :-
    pascal(Z),
    Z = [_, _ | Rows], % we only care about 2nd row on up. ([1,2,1])
    succ(DecN, N), length(CheckRows, DecN), prefix(CheckRows, Rows),
    include(primerow, CheckRows, PrimeRows),
    maplist(second, PrimeRows, Ps).

?- main.
