dutch_flag(N) :-
	length(L, N),

	% create the list to sort
	repeat,
	  maplist(init,L),
	\+is_dutch_flag(L) ,
	writeln(L),
	test_sorted(L),

	foldl(\X^Y^Z^(Y = [Red, White, Blue],
		      (	  X = blue
		      ->  append_dl(Blue, [X|U]-U, Blue1),
			  Z = [Red, White, Blue1]
		      ;	  X = red
		      ->  append_dl(Red, [X|U]-U, Red1),
			  Z = [Red1, White, Blue]
		      ;	  append_dl(White, [X|U]-U, White1),
			  Z = [Red, White1, Blue])),
	      L, [R-R, W-W, B-B], [R1, W1, B1]),
	append_dl(R1, W1, B1, Flag-[]),
	write(Flag), nl,
	test_sorted(Flag).

% append lists in O(1)
append_dl(A-B, B-C, A-C).
append_dl(A-B, B-C, C-D, A-D).


init(C) :-
	R is random(3),
	nth0(R, [blue, red, white], C).


test_sorted(Flag) :-
	(   is_dutch_flag(Flag)
	->  write('it is a dutch flag')
	;   write('it is not a dutch flag')),
	nl,nl.

% First color must be red
is_dutch_flag([red | T]) :-
	is_dutch_flag_red(T).


is_dutch_flag_red([red|T]) :-
	is_dutch_flag_red(T);
	% second color must be white
	T = [white | T1],
	is_dutch_flag_white(T1).


is_dutch_flag_white([white | T]) :-
	is_dutch_flag_white(T);
	% last one must be blue
	T = [blue | T1],
	is_dutch_flag_blue(T1).

is_dutch_flag_blue([blue | T]) :-
	is_dutch_flag_blue(T).

is_dutch_flag_blue([]).
