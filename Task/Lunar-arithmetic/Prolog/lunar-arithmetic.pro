number_digits(Number, Digits) :-
    (   ground(Number)
    ->  number_chars(Number, Chars),
        maplist(atom_number, Chars, Digits0),
        reverse(Digits0, Digits)
    ;   reverse(Digits0, Digits),
        maplist(atom_number, Chars, Digits0),
        number_chars(Number, Chars)
    ).

lunar_eval(Expr, Number) :-
    lunar_eval_(Expr, Digits),
    number_digits(Number, Digits).

lunar_eval_(A0 + B0, C) :- !,
    lunar_eval_(A0, A),
    lunar_eval_(B0, B),
    lunar_add(A, B, C).

lunar_eval_(A0 * B0, C) :- !,
    lunar_eval_(A0, A),
    lunar_eval_(B0, B),
    lunar_mul(A, B, C).

lunar_eval_(!(A), C) :- !,
    (   A < 10
    ->  C = 1
    ;   numlist(10, A, As0),
        maplist(number_digits, As0, As),
        foldl(lunar_mul, As, [1], C)
    ).

lunar_eval_(N, D) :-
    integer(N),
    N >= 0,
    number_digits(N, D).

lunar_add([], Cs, Cs) :- !.
lunar_add(Cs, [], Cs) :- !.
lunar_add([A | As], [B | Bs], [C | Cs]) :-
    C is max(A, B),
    lunar_add(As, Bs, Cs).

min(A, B, C) :- C is min(A, B).

lunar_mul(As0, Bs0, Cs) :-
    length(As0, ALen),
    length(Bs0, BLen),
    (   ALen < BLen
    ->  Bs = As0, As = Bs0
    ;   As = As0, Bs = Bs0
    ),
    findall(Row, (
        nth0(N, Bs, B),
        length(Zeros, N),
        maplist(=(0), Zeros),
        maplist(min(B), As, Row0),
        append(Zeros, Row0, Row)
    ), [Row | Rows]),
    foldl(lunar_add, Rows, Row, Cs).

lunar_evens(E)   :- between(0, inf, N), lunar_eval(2 * N, E).
lunar_squares(S) :- between(0, inf, S0), lunar_eval(S0 * S0, S).

lunar_factorials(F) :- lunar_factorials(1, 1, F).

lunar_factorials(_, F, F).
lunar_factorials(P0, F0, F) :-
    succ(P0, P1),
    lunar_eval(P1 * F0, F1),
    lunar_factorials(P1, F1, F).

lunar_nonmonotonic_square(P) :- lunar_nonmonotonic_square(1, 1, P).

lunar_nonmonotonic_square(P0, S0, P) :-
    succ(P0, P1),
    lunar_eval(P1 * P1, S1),
    (   S1 < S0
    ->  P = P1
    ;   lunar_nonmonotonic_square(P1, S1, P)
    ).

task :-
    writeln("Lunar addition:"),
    foreach((
        member(Addition, [
            976 + 348,
            23 + 321,
            232 + 35,
            123 + 32192 + 415 + 8
        ]),
        lunar_eval(Addition, Result)
    ), (
        writeln(Addition=Result)
    )),

    writeln("\nLunar multiplication:"),
    foreach((
        member(Multiplication, [
            978 * 348,
            23 * 321,
            232 * 35,
            123 * 32192 * 415 * 8
        ]),
        lunar_eval(Multiplication, Result)
    ), (
        writeln(Multiplication=Result)
    )),

    writeln("\nFirst 20 distinct even numbers:"),
    findall(Even, limit(20, distinct(lunar_evens(Even))), Evens),
    atomic_list_concat(Evens, ' ', ResultEvens),
    writeln(ResultEvens),

    writeln("\nFirst 20 lunar squares:"),
    findall(Square, limit(20, lunar_squares(Square)), Squares),
    atomic_list_concat(Squares, ' ', ResultSquares),
    writeln(ResultSquares),

    writeln("\nFirst 18 lunar factorials:"),
    findall(Factorial, limit(18, lunar_factorials(Factorial)), Factorials),
    atomic_list_concat(Factorials, ' ', ResultFactorials),
    writeln(ResultFactorials),

    writeln("\nFirst lunar square smaller than the previous:"),
    lunar_nonmonotonic_square(NR),
    succ(NR0, NR),
    lunar_eval(NR0 * NR0, NS0),
    lunar_eval(NR * NR, NS),
    writeln(NR^2=NS),
    writeln(NR0^2=NS0).
