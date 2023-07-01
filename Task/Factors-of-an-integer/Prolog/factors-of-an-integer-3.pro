between(X,Y,Z) :-
  integer(X) ,
  integer(Y) ,
  X =< Z ,
  between1(X,Y,Z)
  .

between1(X,Y,X) :-
  X =< Y
  .
between1(X,Y,Z) :-
  X < Y ,
  X1 is X+1 ,
  between1(X1,Y,Z)
  .
