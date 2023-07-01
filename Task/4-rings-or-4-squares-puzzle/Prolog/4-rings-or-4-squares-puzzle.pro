:- use_module(library(clpfd)).

% main predicate
my_sum(Min, Max, Top, LL):-
    L = [A,B,C,D,E,F,G],
    L ins Min..Max,
    (   Top == 0
    ->  all_distinct(L)
    ;    true),
    R #= A+B,
    R #= B+C+D,
    R #= D+E+F,
    R #= F+G,
    setof(L, labeling([ff], L), LL).


my_sum_1(Min, Max) :-
    my_sum(Min, Max, 0, LL),
    maplist(writeln, LL).

my_sum_2(Min, Max, Len) :-
    my_sum(Min, Max, 1, LL),
    length(LL, Len).
