:- use_module(library(clpfd)).

% helper to perform the operation with just a number.
compound_time(N) :-
    times(N, R),
    format('~p: ', N),
    write_times(R).

% write out the results in the 'special' format.
write_times([[Tt, Val]|T]) :-
    dif(T, []),
    format('~w ~w, ', [Val, Tt]),
    write_times(T).
write_times([[Tt, Val]|[]]) :-
    format('~w ~w~n', [Val, Tt]).


% this predicate is the main predicate, it takes either N
% or a list of split values to get N, or both.
times(N, R) :-
    findall(T, time_type(T,_), TTs),
    times(TTs, N, R).

% do the split, if there is a 1 or greater add to a list of results.
times([], _, []).
times([Tt|T], N, Rest) :-
    time_type(Tt, Div),
    Val #= N // Div,
    Val #< 1,
    times(T, N, Rest).
times([Tt|T], N, [[Tt,Val]|Rest]) :-
    time_type(Tt, Div),
    Val #= N // Div,
    Val #>= 1,
    Rem #= N mod Div,
    times(T, Rem, Rest).


% specifify the different time split types
time_type(wk, 60 * 60 * 24 * 7).
time_type(d, 60 * 60 * 24).
time_type(hr, 60 * 60).
time_type(min, 60).
time_type(sec, 1).
