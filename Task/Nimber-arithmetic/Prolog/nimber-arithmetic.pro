% highest power of 2 that divides a given number
hpo2(N, P):-
    P is N /\ -N.

% base 2 logarithm of the highest power of 2 dividing a given number
lhpo2(N, Q):-
    hpo2(N, M),
    lhpo2_(M, 0, Q).

lhpo2_(M, Q, Q):-
    1 is M mod 2,
    !.
lhpo2_(M, Q1, Q):-
    M1 is M >> 1,
    Q2 is Q1 + 1,
    lhpo2_(M1, Q2, Q).

% nim-sum of two numbers
nimsum(X, Y, Sum):-
    Sum is X xor Y.

% nim-product of twp numbers
nimprod(X, Y, Product):-
    (X < 2 ; Y < 2),
    !,
    Product is X * Y.
nimprod(X, Y, Product):-
    hpo2(X, H),
    X > H,
    !,
    nimprod(H, Y, P1),
    X1 is X xor H,
    nimprod(X1, Y, P2),
    Product is P1 xor P2.
nimprod(X, Y, Product):-
    hpo2(Y, H),
    H < Y,
    !,
    nimprod(Y, X, Product).
nimprod(X, Y, Product):-
    lhpo2(X, Xp),
    lhpo2(Y, Yp),
    Comp is Xp /\ Yp,
    (Comp == 0 ->
        Product is X * Y
        ;
        hpo2(Comp, H),
        X1 is X >> H,
        Y1 is Y >> H,
        Z is 3 << (H - 1),
        nimprod(X1, Y1, P),
        nimprod(P, Z, Product)
     ).

print_row(N, B, Function):-
    writef('%3r |', [B]),
    Goal =.. [Function, A, B, C],
    forall(between(0, N, A), (Goal, writef('%3r', [C]))),
    nl.

print_table(N, Operator, Function):-
    writef('  %w |', [Operator]),
    forall(between(0, N, A), writef('%3r', [A])),
    writef('\n --- -', []),
    forall(between(0, N, _), writef('---', [])),
    nl,
    forall(between(0, N, A), print_row(N, A, Function)).

main:-
    print_table(15, '+', nimsum),
    nl,
    print_table(15, '*', nimprod),
    nl,
    A = 21508, B = 42689,
    nimsum(A, B, Sum),
    nimprod(A, B, Product),
    writef('%w + %w = %w\n', [A, B, Sum]),
    writef('%w * %w = %w\n', [A, B, Product]).
