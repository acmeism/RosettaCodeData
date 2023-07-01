church_zero(z).

church_successor(Z, c(Z)).

church_add(z, Z, Z).
church_add(c(X), Y, c(Z)) :-
    church_add(X, Y, Z).

church_multiply(z, _, z).
church_multiply(c(X), Y, R) :-
    church_add(Y, S, R),
    church_multiply(X, Y, S).

% N ^ M
church_power(z, z, z).
church_power(N, c(z), N).
church_power(N, c(c(Z)), R) :-
    church_multiply(N, R1, R),
    church_power(N, c(Z), R1).

int_church(0, z).
int_church(I, c(Z)) :-
    int_church(Is, Z),
    succ(Is, I).

run :-
    int_church(3, Three),
    church_successor(Three, Four),
    church_add(Three, Four, Sum),
    church_multiply(Three, Four, Product),
    church_power(Four, Three, Power43),
    church_power(Three, Four, Power34),

    int_church(ISum, Sum),
    int_church(IProduct, Product),
    int_church(IPower43, Power43),
    int_church(IPower34, Power34),

    !,
    maplist(format('~w '), [ISum, IProduct, IPower43, IPower34]),
    nl.
