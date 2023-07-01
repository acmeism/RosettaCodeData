:- use_module(library(func)).

%% Implementation logic:

test_for_repstring(String, (String, Result, Reps)) :-
    ( setof(Rep, repstring(String, Rep), Reps)
    -> Result = 'no repstring'
    ;  Result = 'repstrings', Reps = []
    ).

repstring(Codes, R) :-
    RepLength = between(1) of (_//2) of length $ Codes,
    length(R, RepLength),
    phrase( (rep(R), prefix(~,R)),
            Codes).

rep(X) --> X, X.
rep(X) --> X, rep(X).


%% Demonstration output:

test_strings([`1001110011`, `1110111011`, `0010010010`, `1010101010`,
              `1111111111`, `0100101101`, `0100100`, `101`, `11`, `00`, `1`]).

report_repstring((S,Result,Reps)):-
    format('~s -- ~w: ', [S, Result]),
    foreach(member(R, Reps), format('~s, ', [R])), nl.

report_repstrings :-
    Results = maplist(test_for_repstring) $ test_strings(~),
    maplist(report_repstring, Results).
