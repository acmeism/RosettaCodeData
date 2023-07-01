hanoi(N, Src, Aux, Dest, Moves-NMoves) :-
  NMoves is 2^N - 1,
  length(Moves, NMoves),
  phrase(move(N, Src, Aux, Dest), Moves).


move(1, Src, _, Dest) --> !,
  [Src->Dest].

move(2, Src, Aux, Dest) --> !,
  [Src->Aux,Src->Dest,Aux->Dest].

move(N, Src, Aux, Dest) -->
  { succ(N0, N) },
  move(N0, Src, Dest, Aux),
  move(1, Src, Aux, Dest),
  move(N0, Aux, Src, Dest).
