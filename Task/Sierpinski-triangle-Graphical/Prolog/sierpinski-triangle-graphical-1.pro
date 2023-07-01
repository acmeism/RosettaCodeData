sierpinski(N) :-
	sformat(A, 'Sierpinski order ~w', [N]),
	new(D, picture(A)),
	draw_Sierpinski(D, N, point(350,50), 600),
	send(D, size, size(690,690)),
	send(D, open).

draw_Sierpinski(Window, 1, point(X, Y), Len) :-
	X1 is X - round(Len/2),
	X2 is X + round(Len/2),
	Y1 is Y + Len * sqrt(3) / 2,
	send(Window, display, new(Pa, path)),
        (
	   send(Pa, append, point(X, Y)),
	   send(Pa, append, point(X1, Y1)),
	   send(Pa, append, point(X2, Y1)),
	   send(Pa, closed, @on),
	   send(Pa, fill_pattern,  colour(@default, 0, 0, 0))
	).


draw_Sierpinski(Window, N, point(X, Y), Len) :-
	Len1 is round(Len/2),
	X1 is X - round(Len/4),
	X2 is X + round(Len/4),
	Y1 is Y + Len * sqrt(3) / 4,
	N1 is N - 1,
	draw_Sierpinski(Window, N1, point(X, Y), Len1),
	draw_Sierpinski(Window, N1, point(X1, Y1), Len1),
	draw_Sierpinski(Window, N1, point(X2, Y1), Len1).
