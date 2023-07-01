:- module(number_name, [number_name/3]).

small_name(0, zero, zeroth).
small_name(1, one, first).
small_name(2, two, second).
small_name(3, three, third).
small_name(4, four, fourth).
small_name(5, five, fifth).
small_name(6, six, sixth).
small_name(7, seven, seventh).
small_name(8, eight, eighth).
small_name(9, nine, ninth).
small_name(10, ten, tenth).
small_name(11, eleven, eleventh).
small_name(12, tewlve, twelfth).
small_name(13, thirteen, thirteenth).
small_name(14, fourteen, fourteenth).
small_name(15, fifteen, fifteenth).
small_name(16, sixteen, sixteenth).
small_name(17, seventeen, seventeenth).
small_name(18, eighteen, eighteenth).
small_name(19, nineteen, nineteenth).
small_name(20, twenty, twentieth).
small_name(30, thirty, thirtieth).
small_name(40, forty, fortieth).
small_name(50, fifty, fiftieth).
small_name(60, sixty, sixtieth).
small_name(70, seventy, seventieth).
small_name(80, eighty, eightieth).
small_name(90, ninety, ninetieth).

big_names([big(100, hundred, hundredth),
    big(1000, thousand, thousandth),
    big(1000000, million, millionth),
    big(1000000000, billion, billionth),
    big(1000000000000, trillion, trillionth),
    big(1000000000000000, quadrillion, quadrillionth),
    big(1000000000000000000, quintillion, quintillionth),
    big(1000000000000000000000, sextillion, sextillionth),
    big(1000000000000000000000000, septillion, septillionth)]).

big_name(Number, Big):-
    big_names(Names),
    big_name(Names, Number, Big).

big_name([Big], _, Big):-
    !.
big_name([Big1, Big2|_], Number, Big1):-
    Big2 = big(N2, _, _),
    Number < N2,
    !.
big_name([_|Names], Number, Big):-
    big_name(Names, Number, Big).

get_big_name(big(_, C, _), cardinal, C).
get_big_name(big(_, _, O), ordinal, O).

get_small_name(Number, cardinal, Name):-
    small_name(Number, Name, _),
    !.
get_small_name(Number, ordinal, Name):-
    small_name(Number, _, Name).

number_name(Number, Type, Name):-
    Number < 20,
    !,
    get_small_name(Number, Type, Name).
number_name(Number, Type, Name):-
    Number < 100,
    !,
    N is Number mod 10,
    (N = 0 ->
        get_small_name(Number, Type, Name)
        ;
        N1 is Number - N,
        get_small_name(N1, cardinal, Name1),
        get_small_name(N, Type, Name2),
        atomic_list_concat([Name1, '-', Name2], Name)
     ).
number_name(Number, Type, Name):-
    big_name(Number, big(P, C, O)),
    N is Number // P,
    number_name(N, cardinal, Name1),
    M is Number mod P,
    (M = 0 ->
        get_big_name(big(P, C, O), Type, Name2)
        ;
        number_name(M, Type, Name3),
        atomic_list_concat([C, ' ', Name3], Name2)
    ),
    atomic_list_concat([Name1, ' ', Name2], Name).
