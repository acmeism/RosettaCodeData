is_evil(Number) :- popcount(Number) mod 2 =:= 0.

:-  numlist(0, 29, Powers),
    maplist([P0, P] >> (P is popcount(3 ^ P0)), Powers, PowerPopcounts),
    numlist(0, 59, Numbers),
    partition(is_evil, Numbers, EvilNumbers, OdiousNumbers),
    writeln('The pop counts of the first 30 powers of 3 are:'),
    writeln(PowerPopcounts),
    writeln('The first 30 evil numbers are:'),
    writeln(EvilNumbers),
    writeln('The first 30 odious numbers are:'),
    writeln(OdiousNumbers).
