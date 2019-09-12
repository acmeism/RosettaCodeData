rfor(Hi,Lo,Hi) :- Hi >= Lo.
rfor(Hi,Lo,Val) :- Hi > Lo, H is Hi - 1, !, rfor(H,Lo,Val).

reverse_iter :-
  rfor(10,0,Val), write(Val), nl, fail.
reverse_iter.
