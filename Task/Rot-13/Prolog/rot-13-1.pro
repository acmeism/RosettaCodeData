:- use_module(library(ctypes)).

runtime_entry(start) :-
	prompt(_, ''),
	rot13.

rot13 :-
	get0(Ch),
	(   is_endfile(Ch) ->
		true
	;   rot13_char(Ch, Rot),
	    put(Rot),
	    rot13
	).

rot13_char(Ch, Rot) :-
	(   is_alpha(Ch) ->
		to_upper(Ch, Up),
		Letter is Up - 0'A,
		Rot is Ch + ((Letter + 13) mod 26) - Letter
	;   Rot = Ch
	).
