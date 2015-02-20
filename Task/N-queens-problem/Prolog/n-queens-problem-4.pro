:- initialization(main).


queens(N,Qs) :- bagof(X, between(1,N,X), Xs), place(Xs,[],Qs).

place(Xs,Qs,Res) :-
    Xs = [] -> Res = Qs
  ; select(Q,Xs,Ys), not_diag(Q,Qs,1), place(Ys,[Q|Qs],Res)
  .

not_diag(_, []     , _).
not_diag(Q, [Qh|Qs], D) :-
     abs(Q - Qh) =\= D, D1 is D + 1, not_diag(Q,Qs,D1).


main :- findall(Qs, (queens(8,Qs), write(Qs), nl), _), halt.
