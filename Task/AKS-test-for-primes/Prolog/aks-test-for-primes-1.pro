  prime(P) :-
    pascal([1,P|Xs]),
    append(Xs, [1], Rest),
    forall( member(X,Xs), 0 is X mod P).
