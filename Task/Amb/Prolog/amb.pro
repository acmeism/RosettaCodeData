amb(E, [E|_]).
amb(E, [_|ES]) :- amb(E, ES).

joins(Left, Right) :-
  append(_, [T], Left),
  append([R], _, Right),
  ( T \= R -> amb(_, [])  % (explicitly using amb fail as required)
  ; true ).

amb_example([Word1, Word2, Word3, Word4]) :-
  amb(Word1, ["the","that","a"]),
  amb(Word2, ["frog","elephant","thing"]),
  amb(Word3, ["walked","treaded","grows"]),
  amb(Word4, ["slowly","quickly"]),
  joins(Word1, Word2),
  joins(Word2, Word3),
  joins(Word3, Word4).
