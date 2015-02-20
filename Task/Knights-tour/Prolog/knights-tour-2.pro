:- initialization(main).


board_size(8).
in_board(X*Y) :- board_size(N), between(1,N,Y), between(1,N,X).


% express jump-graph in dynamic "move"-rules
make_graph :-
    findall(_, (in_board(P), assert_moves(P)), _).

    % where
    assert_moves(P) :-
        findall(_, (can_move(P,Q), asserta(move(P,Q))), _).

    can_move(X*Y,Q) :-
        ( one(X,X1), two(Y,Y1) ; two(X,X1), one(Y,Y1) )
      , Q = X1*Y1, in_board(Q)
      . % where
        one(M,N) :- succ(M,N)  ; succ(N,M).
        two(M,N) :- N is M + 2 ; N is M - 2.



hamiltonian(P,Pn) :-
    board_size(N), Size is N * N
  , hamiltonian(P,Size,[],Ps), enumerate(Size,Ps,Pn)
  .
    % where
    enumerate(_, []    , []      ).
    enumerate(N, [P|Ps], [N:P|Pn]) :- succ(M,N), enumerate(M,Ps,Pn).


hamiltonian(P,N,Ps,Res) :-
    N =:= 1 -> Res = [P|Ps]
  ; warnsdorff(Ps,P,Q), succ(M,N)
  , hamiltonian(Q,M,[P|Ps],Res)
  .
    % where
    warnsdorff(Ps,P,Q) :-
        moves(Ps,P,Qs), maplist(next_moves(Ps), Qs, Xs)
      , keysort(Xs,Ys), member(_-Q,Ys)
      .
    next_moves(Ps,Q,L-Q) :- moves(Ps,Q,Rs), length(Rs,L).

    moves(Ps,P,Qs) :-
        findall(Q, (move(P,Q), \+ member(Q,Ps)), Qs).



show_path(Pn)  :- findall(_, (in_board(P), show_cell(Pn,P)), _).
    % where
    show_cell(Pn,X*Y) :-
        member(N:X*Y,Pn), format('%3.0d',[N]), board_size(X), nl.


main :- make_graph, hamiltonian(5*3,Pn), show_path(Pn), halt.
