:- initialization(main, main).
:- set_prolog_flag(double_quotes, codes).
:- use_module(library(ansi_term), [ansi_format/3]).
:- use_module(library(dcg/basics), [blanks/2, eol/2, eos/2, string_without/4]).
:- use_module(library(dcg/high_order), [optional/4, sequence/4]).

grid(Grid) --> sequence(row, Grid), blanks.
row(Row)   --> string_without("\n", Row), { Row \= [] }, eol.

:- meta_predicate maplist_with_nth0(3, +, -).
maplist_with_nth0(Goal, List0, List) :-
    length(List0, Length),
    succ(LastIndex, Length),
    numlist(0, LastIndex, N0s),
    maplist(Goal, N0s, List0, List).

:- meta_predicate map_grid0(3, +, -).
map_grid0(Goal, Grid0, Grid) :-
    maplist_with_nth0({Goal}/[Y, Row0, Row] >> (
        maplist_with_nth0({Goal, Y}/[X, T0, T] >> (
            call(Goal, yx(Y, X), T0, T)
        ), Row0, Row)
    ), Grid0, Grid).

yxth0(yx(Y, X)) --> nth0(Y), nth0(X).

moore_neighbourhood(yx(Y0, X0), yx(Y, X)) :- succ(Y0, Y), ( succ(X, X0) ; X = X0 ; succ(X0, X) ).
moore_neighbourhood(yx(Y, X0), yx(Y, X))  :- succ(X, X0) ; succ(X0, X).
moore_neighbourhood(yx(Y0, X0), yx(Y, X)) :- succ(Y, Y0), ( succ(X, X0) ; X = X0 ; succ(X0, X) ).

transition(_, _, 0' , 0' ) :- !.
transition(_, _, 0'H, 0't) :- !.
transition(_, _, 0't, 0'.) :- !.
transition(Grid, Here, 0'., State) :-
    aggregate_all(count, (
        moore_neighbourhood(Here, There),
        yxth0(There, Grid, 0'H)
    ), AdjacentHeads),
    (   between(1, 2, AdjacentHeads)
    ->  State = 0'H
    ;   State = 0'.
    ).

char_attributes(0'., [bg(yellow)]).
char_attributes(0' , []).
char_attributes(0't, [bg(red)]).
char_attributes(0'H, [bg(blue)]).

display(Grid) :-
    maplist([Row] >> (
        maplist([Char] >> (
            char_attributes(Char, Attributes),
            ansi_format(Attributes, "~c", [Char])
        ), Row),
        nl
    ), Grid).

simulate(Grid0) :-
    map_grid0(transition(Grid0), Grid0, Grid),
    display(Grid),
    sleep(0.25),
    length(Grid, Height),
    format("\e[~dA", [Height]),
    simulate(Grid).

main([Filename]) :-
    format("Welcome to WireWorld! Press ^C to exit.~n~n", []),
    once(phrase_from_file(grid(Grid), Filename)),
    simulate(Grid).
