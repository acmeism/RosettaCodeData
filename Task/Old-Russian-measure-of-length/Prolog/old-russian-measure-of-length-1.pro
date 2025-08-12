:- module(old_russian_unit_conversion, [convert/2]).
:- set_prolog_flag(prefer_rationals, true).     % Int/Int --> Rational
:- set_prolog_flag(rational_syntax,  natural).  % Write as `1/3`
:- use_module(library(clpq)).

%   The core conversion logic

convert(A, B) :- convert_shag(A, S), convert_shag(B, S).

convert_shag(tochka(T), S)       :- { S / T  = 1 / 2800 }.
convert_shag(millimetre(MM), S)  :- { S / MM = 10 / 7112 }.
convert_shag(liniya(L), S)       :- { S / L  = 1 / 280  }.
convert_shag(centimetre(CM), S)  :- { S / CM = 100 / 7112 }.
convert_shag(dyuym(D), S)        :- { S / D  = 1 / 28 }.
convert_shag(vyershok(V), S)     :- { S / V  = 1 / 16 }.
convert_shag(ladon(L), S)        :- { S / L  = 3 / 28 }.
convert_shag(pyad(P), S)         :- { S / P  = 1 / 4 }.
convert_shag(fut(F), S)          :- { S / F  = 3 / 7 }.
convert_shag(lokot(L), S)        :- { S / L  = 9 / 14  }.
convert_shag(shag(S), S).
convert_shag(metre(M), S)        :- {  M / S = 7112 / 10000 }.
convert_shag(sazhen(Sz), S)      :- { Sz / S = 1 / 3 }.
convert_shag(kilometre(KM), S)   :- { KM / S = 10668 / 15000000 }.
convert_shag(vyersta(V), S)      :- {  V / S = 1 / 1500  }.

%   The command line interface

:- initialization(main, main).

main([AmountA, UnitA]) :-
    atom_number(AmountA, NumberA),
    build_term(UnitA, NumberA, TermA),
    !,
    format("~w ~w is~n", [AmountA, UnitA]),
    functor(TermA, NormalisedA, _),
    foreach(
        (   convert(TermA, TermB),
            TermB =.. [UnitB, NumberB],
            UnitB \= NormalisedA
        ),
        format("~|~` t~f~20+ ~w~n", [NumberB, UnitB])
    ).

main([AmountA, UnitA, UnitB]) :-
    atom_number(AmountA, NumberA),
    build_term(UnitA, NumberA, TermA),
    build_term(UnitB, NumberB, TermB),
    !,
    convert(TermA, TermB),
    format("~w ~w is ~f ~w~n", [AmountA, UnitA, NumberB, UnitB]).

main(_) :- with_output_to(user_error, format("Invalid argument~n", [])), halt(22).

build_term(A0, N, T) :- normalise(A0, A), T =.. [A, N].

% user input normalisation

normalise(millimetre, millimetre).
normalise(millimeter, millimetre).
normalise(millimetres, millimetre).
normalise(millimeters, millimetre).
normalise(centimetre, centimetre).
normalise(centimeter, centimetre).
normalise(centimetre, centimetre).
normalise(centimetres, centimetre).
normalise(metre, metre).
normalise(meter, metre).
normalise(meters, metre).
normalise(metres, metre).
normalise(kilometre, kilometre).
normalise(kilometer, kilometre).
normalise(kilometers, kilometre).
normalise(kilometres, kilometre).
normalise(tochka, tochka).
normalise(точка, tochka).
normalise(liniya, liniya).
normalise(линия, liniya).
normalise(dyuym, dyuym).
normalise(дюйм, dyuym).
normalise(pyerst, dyuym).
normalise(перст, dyuym).
normalise(vyershok, vyershok).
normalise(вершок, vyershok).
normalise(ladon, ladon).
normalise(ладонь, ladon).
normalise(pyad, pyad).
normalise(пядь, pyad).
normalise(четверть, pyad).
normalise(chyetvyert, pyad).
normalise(fut, fut).
normalise(фут, fut).
normalise(lokot, lokot).
normalise(локоть, lokot).
normalise(shag, shag).
normalise(шаг, shag).
normalise(arshin, shag).
normalise(аршин, shag).
normalise(sazhen, sazhen).
normalise(сажень, sazhen).
normalise(vyersta, vyersta).
normalise(верста, vyersta).
