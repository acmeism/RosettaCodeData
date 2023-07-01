:- dynamic top/1.

sierpinski_iterate(N) :-
	retractall(top(_)),
	sformat(A, 'Sierpinski order ~w', [N]),
	new(D, picture(A)),
	draw_Sierpinski_iterate(D, N, point(550, 50)),
	send(D, open).

draw_Sierpinski_iterate(Window, N, point(X,Y)) :-
	assert(top([point(X,Y)])),
	NbTours is 2 ** (N  - 1),
	% Size is given here to preserve the "small" triangles when N is big
	Len is 10,
	forall(between(1, NbTours, _I),
	       (   retract(top(Lst)),
		   assert(top([])),
		   forall(member(P, Lst),
			  draw_Sierpinski(Window, P, Len)))).

draw_Sierpinski(Window, point(X, Y), Len) :-
	X1 is X - round(Len/2),
	X2 is X + round(Len/2),
	Y1 is Y + round(Len * sqrt(3) / 2),
	send(Window, display, new(Pa, path)),
        (
	   send(Pa, append, point(X, Y)),
	   send(Pa, append, point(X1, Y1)),
	   send(Pa, append, point(X2, Y1)),
	   send(Pa, closed, @on),
	   send(Pa, fill_pattern,  colour(@default, 0, 0, 0))
	),
	retract(top(Lst)),
	(   member(point(X1, Y1), Lst) -> select(point(X1,Y1), Lst, Lst1)
	;   Lst1 = [point(X1, Y1)|Lst]),

	(   member(point(X2, Y1), Lst1) -> select(point(X2,Y1), Lst1, Lst2)
	;   Lst2 = [point(X2, Y1)|Lst1]),

	assert(top(Lst2)).
