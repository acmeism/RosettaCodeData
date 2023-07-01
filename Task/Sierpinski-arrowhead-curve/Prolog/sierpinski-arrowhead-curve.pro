main:-
    write_sierpinski_arrowhead('sierpinski_arrowhead.svg', 600, 8).

write_sierpinski_arrowhead(File, Size, Order):-
    open(File, write, Stream),
    format(Stream,
           "<svg xmlns='http://www.w3.org/2000/svg' width='~d' height='~d'>\n",
           [Size, Size]),
    write(Stream, "<rect width='100%' height='100%' fill='white'/>\n"),
    write(Stream, "<path stroke-width='1' stroke='black' fill='none' d='"),
    Margin = 20.0,
    Side is Size - 2.0 * Margin,
    X = Margin,
    Y is 0.5 * Size + 0.25 * sqrt(3) * Side,
    Cursor = cursor(X, Y, 0),
    (Order mod 2 == 1 -> turn(Cursor, -60, Cursor1) ; Cursor1 = Cursor),
    format(Stream, "M~g,~g", [X, Y]),
    curve(Stream, Order, Side, Cursor1, _, 60),
    write(Stream, "'/>\n</svg>\n"),
    close(Stream).

turn(cursor(X, Y, A), Angle, cursor(X, Y, A1)):-
    A1 is (A + Angle) mod 360.

draw_line(Stream, cursor(X, Y, A), Length, cursor(X1, Y1, A)):-
    Theta is (pi * A)/180.0,
    X1 is X + Length * cos(Theta),
    Y1 is Y + Length * sin(Theta),
    format(Stream, "L~g,~g", [X1, Y1]).

curve(Stream, 0, Length, Cursor, Cursor1, _):-
    !,
    draw_line(Stream, Cursor, Length, Cursor1).
curve(Stream, Order, Length, Cursor, Cursor1, Angle):-
    Order1 is Order - 1,
    Angle1 is -Angle,
    Length2 is Length/2.0,
    curve(Stream, Order1, Length2, Cursor, Cursor2, Angle1),
    turn(Cursor2, Angle, Cursor3),
    curve(Stream, Order1, Length2, Cursor3, Cursor4, Angle),
    turn(Cursor4, Angle, Cursor5),
    curve(Stream, Order1, Length2, Cursor5, Cursor1, Angle1).
