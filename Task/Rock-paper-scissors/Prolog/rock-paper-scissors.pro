play :-
  findall(P,beats(P,_),Prev),
  play(Prev).

play(Prev) :-
  write('your choice? '),
  read(P),
  random_member(C, Prev),
  format('The computer chose ~p~n', C),
  result(C,P,Prev,Next),
  !,
  play(Next).

result(C,P,R,[C|R]) :-
  beats(C,P),
  format('Computer wins.~n').
result(C,P,R,[B|R]) :-
  beats(P,C),
  beats(B,P),
  format('You win!~n').
result(C,C,R,[B|R]) :-
  beats(B,C),
  format('It is a draw~n').

beats(paper, rock).
beats(rock, scissors).
beats(scissors, paper).
