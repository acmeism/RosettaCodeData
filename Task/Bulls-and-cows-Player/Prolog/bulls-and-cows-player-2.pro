bulls_and_cows :-
	retractall('ia.pl':guess(_,_)),
	retractall(coups(_)),
	assert(coups(1)),

	repeat,
	(   tirage(Ms)
	->  maplist(add_1, Ms, Ms1),
	    atomic_list_concat(Ms1, Guess),
	    retract(coups(Coup)),
	    Coup_1 is Coup + 1,
	    assert(coups(Coup_1)),
	    format('~w My guess ~w~n', [Coup, Guess]),
	    write('Bulls : '), read(Bulls),
	    write('Cows  : '), read(Cows), nl,
	    assert('ia.pl':guess(Ms, [Bulls, Cows])),
	    Bulls = 4
	;   writeln('Sorry, I can''t find a solution !'), true).

add_1(X, Y) :-
	Y is X + 1.
