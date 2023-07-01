leap_year(L) :-
	partition(is_leap_year, L, LIn, LOut),
	format('leap years : ~w~n', [LIn]),
	format('not leap years : ~w~n', [LOut]).

is_leap_year(Year) :-
	R4 is Year mod 4,
	R100 is Year mod 100,
	R400 is Year mod 400,
	(   (R4 = 0, R100 \= 0); R400 = 0).
