:- dynamic level/1.
		
setup :-
	retractall(level(_)),
	assert(level(1)).
		
step :-
	level(Level),
	random_between(0,3,N),
	(
		N > 0 ->
			succ(Level, NewLevel), format('Climbed up to ~d~n', NewLevel)
		;
			succ(NewLevel, Level), format('Fell down to ~d~n', NewLevel)
	),
	retractall(level(Level)),
	assert(level(NewLevel)),
	N > 0. % Fail if 0 because that is a non step up.
