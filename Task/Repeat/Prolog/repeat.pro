repeat(_, 0).
repeat(Callable, Times) :-
	succ(TimesLess1, Times),
	Callable,
	repeat(Callable, TimesLess1).

test :- write('Hello, World'), nl.	
test(Name) :- format('Hello, ~w~n', Name).
