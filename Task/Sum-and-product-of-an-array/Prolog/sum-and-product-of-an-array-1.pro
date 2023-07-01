sum([],0).
sum([H|T],X) :- sum(T,Y), X is H + Y.
product([],1).
product([H|T],X) :- product(T,Y), X is H * X.
