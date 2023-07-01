main:-
    write_koch_snowflake('koch_snowflake.svg').

write_koch_snowflake(File):-
    open(File, write, Stream),
    koch_snowflake(Stream, 600, 5),
    close(Stream).

koch_snowflake(Stream, Size, N):-
    format(Stream, "<svg xmlns='http://www.w3.org/2000/svg' width='~d' height='~d'>\n",
           [Size, Size]),
    write(Stream, "<rect width='100%' height='100%' fill='black'/>\n"),
    write(Stream, "<path stroke-width='1' stroke='white' fill='none' d='"),
    Sqrt3_2 = 0.86602540378444,
    Length is Size * Sqrt3_2 * 0.95,
    X0 is (Size - Length)/2,
    Y0 is Size/2 - Length * Sqrt3_2/3,
    X1 is X0 + Length/2,
    Y1 is Y0 + Length * Sqrt3_2,
    X2 is X0 + Length,
    format(Stream, 'M ~g,~g ', [X0, Y0]),
    koch_curve(Stream, X0, Y0, X1, Y1, N),
    koch_curve(Stream, X1, Y1, X2, Y0, N),
    koch_curve(Stream, X2, Y0, X0, Y0, N),
    write(Stream, "z'/>\n</svg>\n").

koch_curve(Stream, _, _, X1, Y1, 0):-
    !,
    format(Stream, 'L ~g,~g\n', [X1, Y1]).
koch_curve(Stream, X0, Y0, X1, Y1, N):-
    N > 0,
    Sqrt3_2 = 0.86602540378444,
    N1 is N - 1,
    Dx is X1 - X0,
    Dy is Y1 - Y0,
    X2 is X0 + Dx/3,
    Y2 is Y0 + Dy/3,
    X3 is X0 + Dx/2 - Dy * Sqrt3_2/3,
    Y3 is Y0 + Dy/2 + Dx * Sqrt3_2/3,
    X4 is X0 + 2 * Dx/3,
    Y4 is Y0 + 2 * Dy/3,
    koch_curve(Stream, X0, Y0, X2, Y2, N1),
    koch_curve(Stream, X2, Y2, X3, Y3, N1),
    koch_curve(Stream, X3, Y3, X4, Y4, N1),
    koch_curve(Stream, X4, Y4, X1, Y1, N1).
