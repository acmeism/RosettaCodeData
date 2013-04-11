rot13(Str, SR) :-
	maplist(rot, Str, Str1),
	string_to_list(SR, Str1).

rot(C, C1) :-
	(   member(C, "abcdefghijklmABCDEFGHIJKLM") -> C1 is C+13;
	    (	member(C, "nopqrstuvwxyzNOPQRSTUVWXYZ") -> C1 is C-13; C1 = C)).
