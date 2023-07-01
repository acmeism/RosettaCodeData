main:-
    write_sierpinski_pentagon('sierpinski_pentagon.svg', 600, 5).

write_sierpinski_pentagon(File, Size, Order):-
    open(File, write, Stream),
    format(Stream, "<svg xmlns='http://www.w3.org/2000/svg' width='~d' height='~d'>\n",
       [Size, Size]),
    write(Stream, "<rect width='100%' height='100%' fill='white'/>\n"),
    Margin = 5,
    Radius is Size/2 - 2 * Margin,
    Side is Radius * sin(pi/5) * 2,
    Height is Side * (sin(pi/5) + sin(2 * pi/5)),
    X is Size/2,
    Y is (Size - Height)/2,
    Scale_factor is 1/(2 + cos(2 * pi/5) * 2),
    sierpinski_pentagon(Stream, X, Y, Scale_factor, Side, Order),
    write(Stream, "</svg>\n"),
    close(Stream).

sierpinski_pentagon(Stream, X, Y, _, Side, 1):-
    !,
    write(Stream, "<polygon stroke-width='1' stroke='black' fill='blue' points='"),
    format(Stream, '~g,~g', [X, Y]),
    Angle is 6 * pi/5,
    write_pentagon_points(Stream, Side, Angle, X, Y, 5),
    write(Stream, "'/>\n").
sierpinski_pentagon(Stream, X, Y, Scale_factor, Side, N):-
    Side1 is Side * Scale_factor,
    N1 is N - 1,
    Angle is 6 * pi/5,
    sierpinski_pentagons(Stream, X, Y, Scale_factor, Side1, Angle, N1, 5).

write_pentagon_points(_, _, _, _, _, 0):-!.
write_pentagon_points(Stream, Side, Angle, X, Y, N):-
    N1 is N - 1,
    X1 is X + cos(Angle) * Side,
    Y1 is Y - sin(Angle) * Side,
    Angle1 is Angle + 2 * pi/5,
    format(Stream, ' ~g,~g', [X1, Y1]),
    write_pentagon_points(Stream, Side, Angle1, X1, Y1, N1).

sierpinski_pentagons(_, _, _, _, _, _, _, 0):-!.
sierpinski_pentagons(Stream, X, Y, Scale_factor, Side, Angle, N, I):-
    I1 is I - 1,
    Distance is Side + Side * cos(2 * pi/5) * 2,
    X1 is X + cos(Angle) * Distance,
    Y1 is Y - sin(Angle) * Distance,
    Angle1 is Angle + 2 * pi/5,
    sierpinski_pentagon(Stream, X1, Y1, Scale_factor, Side, N),
    sierpinski_pentagons(Stream, X1, Y1, Scale_factor, Side, Angle1, N, I1).
