member1(X,[H|_]) :- X==H,!.
member1(X,[_|T]) :- member1_(X,T).

distinct([],[]).
distinct([H|T],C) :- member1(H,T),!, distinct(T,C).
distinct([H|T],[H|C]) :- distinct(T,C).
