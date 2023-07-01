% a straight forward adaption from the Ada example
% these imports are needed for Ciao Prolog but needed
% modules will vary with your Prolog system
:- use_module(library(streams)).
:- use_module(library(stream_utils)).
:- use_module(library(lists)).
:- use_module(library(llists)).
:- use_module(library(hiordlib)).
:- use_module(library(random)).
:- use_module(library(format)).

replicate(Term, Times, L) :-
    length(L, Times),
    maplist(=(Term), L).

replace(0, [_|T], E, [E|T]).
replace(X, [H|T0], E, [H|T]) :-
    X0 is X -1,
    replace(X0, T0, E, T).
replace_2d(X, 0, [H|T], E, [R|T]) :-
    replace(X, H, E, R).
replace_2d(X, Y, [H|T0], E, [H|T]) :-
    Y0 is Y -1,
    replace_2d(X, Y0, T0, E, T).

fern_iteration(10000, _X, _Y, Final, Final).
fern_iteration(N, X, Y, I, Final) :-
    random(R),
    ( R =< 0.01
    -> ( X1 is 0.0,
            Y1 is 0.16*Y )
    ; ( R =< 0.86
        -> ( X1 is 0.85*X + 0.04*Y,
                Y1 is -0.04*X + 0.85*Y + 1.6 )
        ; ( R =< 0.93
            -> ( X1 is 0.20*X - 0.26*Y,
                    Y1 is 0.23*X + 0.22*Y + 1.60 )
            ; ( X1 is -0.15*X + 0.28*Y,
                    Y1 is 0.26*X + 0.24*Y + 0.44 )
            ) ) ),
    PointX is 250 + floor(70.0*X1),
    PointY is 750 - floor(70.0*Y1),
    replace_2d(PointX, PointY, I, [0, 255, 0], I1), !,
    N1 is N + 1,
    fern_iteration(N1, X1, Y1, I1, Final).

draw_fern :-
    replicate([0, 0, 0], 500, Row),
    replicate(Row, 750, F),
    fern_iteration(0, 0, 0, F, Fern),
    % the following lines are written for ciao prolog and
    % write to a ppm6 file for viewing
    % adapting to SWI or Scryer should be straighforward
    open('fern.ppm', write, File),
    flatten(Fern, FP),
    format(File, "P6\n~d ~d\n255\n", [500, 750]),
    write_bytes(File, FP),
    close(File).
