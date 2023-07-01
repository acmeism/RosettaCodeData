main:-
    write_sierpinski_carpet('sierpinski_carpet.svg', 486, 4).

write_sierpinski_carpet(File, Size, Order):-
    open(File, write, Stream),
    format(Stream,
           "<svg xmlns='http://www.w3.org/2000/svg' width='~d' height='~d'>\n",
           [Size, Size]),
    write(Stream, "<rect width='100%' height='100%' fill='white'/>\n"),
    Side is Size/3.0,
    sierpinski_carpet(Stream, 0, 0, Side, Order),
    write(Stream, "</svg>\n"),
    close(Stream).

sierpinski_carpet(Stream, X, Y, Side, 0):-
    !,
    X0 is X + Side,
    Y0 is Y + Side,
    write_square(Stream, X0, Y0, Side).
sierpinski_carpet(Stream, X, Y, Side, Order):-
    Order1 is Order - 1,
    Side1 is Side / 3.0,
    X0 is X + Side,
    Y0 is Y + Side,
    X1 is X0 + Side,
    Y1 is Y0 + Side,
    write_square(Stream, X0, Y0, Side),
    sierpinski_carpet(Stream, X, Y, Side1, Order1),
    sierpinski_carpet(Stream, X0, Y, Side1, Order1),
    sierpinski_carpet(Stream, X1, Y, Side1, Order1),
    sierpinski_carpet(Stream, X, Y0, Side1, Order1),
    sierpinski_carpet(Stream, X1, Y0, Side1, Order1),
    sierpinski_carpet(Stream, X, Y1, Side1, Order1),
    sierpinski_carpet(Stream, X0, Y1, Side1, Order1),
    sierpinski_carpet(Stream, X1, Y1, Side1, Order1).

write_square(Stream, X, Y, Side):-
    format(Stream,
           "<rect fill='black' x='~g' y='~g' width='~g' height='~g'/>\n",
           [X, Y, Side, Side]).
