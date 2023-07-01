power_set( [], [[]]).
power_set( [X|Xs], PS) :-
  power_set(Xs, PS1),
  maplist( append([X]), PS1, PS2 ), % i.e. prepend X to each PS1
  append(PS1, PS2, PS).
