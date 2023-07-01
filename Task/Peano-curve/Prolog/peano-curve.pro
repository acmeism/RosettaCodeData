main:-
    write_peano_curve('peano_curve.svg', 656, 4).

write_peano_curve(File, Size, Order):-
    open(File, write, Stream),
    format(Stream,
           "<svg xmlns='http://www.w3.org/2000/svg' width='~d' height='~d'>\n",
           [Size, Size]),
    write(Stream, "<rect width='100%' height='100%' fill='white'/>\n"),
    peano_curve(Stream, "L", 8, 8, 8, 90, Order),
    write(Stream, "</svg>\n"),
    close(Stream).

peano_curve(Stream, Axiom, X, Y, Length, Angle, Order):-
    write(Stream, "<path stroke-width='1' stroke='black' fill='none' d='"),
    format(Stream, 'M~g,~g\n', [X, Y]),
    rewrite(Axiom, Order, S),
    string_chars(S, Chars),
    execute(Stream, X, Y, Length, Angle, Chars),
    write(Stream, "'/>\n").

rewrite(S, 0, S):-!.
rewrite(S0, N, S):-
    string_chars(S0, Chars0),
    rewrite1(Chars0, '', S1),
    N1 is N - 1,
    rewrite(S1, N1, S).

rewrite1([], S, S):-!.
rewrite1([C|Chars], T, S):-
    rewrite2(C, X),
    string_concat(T, X, T1),
    rewrite1(Chars, T1, S).

rewrite2('L', "LFRFL-F-RFLFR+F+LFRFL"):-!.
rewrite2('R', "RFLFR+F+LFRFL-F-RFLFR"):-!.
rewrite2(X, X).

execute(_, _, _, _, _, []):-!.
execute(Stream, X, Y, Length, Angle, ['F'|Chars]):-
    !,
    Theta is (pi * Angle) / 180.0,
    X1 is X + Length * cos(Theta),
    Y1 is Y + Length * sin(Theta),
    format(Stream, 'L~g,~g\n', [X1, Y1]),
    execute(Stream, X1, Y1, Length, Angle, Chars).
execute(Stream, X, Y, Length, Angle, ['+'|Chars]):-
    !,
    Angle1 is (Angle + 90) mod 360,
    execute(Stream, X, Y, Length, Angle1, Chars).
execute(Stream, X, Y, Length, Angle, ['-'|Chars]):-
    !,
    Angle1 is (Angle - 90) mod 360,
    execute(Stream, X, Y, Length, Angle1, Chars).
execute(Stream, X, Y, Length, Angle, [_|Chars]):-
    execute(Stream, X, Y, Length, Angle, Chars).
