pascal(N) :-
	pascal(1, N, [1], [[1]|X]-X, L),
	maplist(my_format, L).

pascal(Max, Max, L, LC, LF) :-
	!,
	make_new_line(L, NL),
	append_dl(LC, [NL|X]-X, LF-[]).

pascal(N, Max, L, NC, LF) :-
	build_new_line(L, NL),
	append_dl(NC, [NL|X]-X, NC1),
	N1 is N+1,
	pascal(N1, Max, NL, NC1, LF).

build_new_line(L, R) :-
	build(L, 0, X-X, R).

build([], V, RC, RF) :-
	append_dl(RC, [V|Y]-Y, RF-[]).

build([H|T], V, RC, R) :-
	V1 is V+H,
	append_dl(RC, [V1|Y]-Y, RC1),
	build(T, H, RC1, R).

append_dl(X1-X2, X2-X3, X1-X3).

% to have a correct output !
my_format([H|T]) :-
	write(H),
	maplist(my_writef, T),
	nl.

my_writef(X) :-
	writef(' %5r', [X]).
