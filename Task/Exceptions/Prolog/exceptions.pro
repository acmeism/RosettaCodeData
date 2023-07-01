foo(X) :-
    \+ integer(X),
    throw(b('not even an int')).
foo(X) :-
    \+ between(1,10,X),
    throw(a('must be between 1 & 10')).
foo(X) :-
    format('~p is a valid number~n', X).

go(X) :-
    catch(
        foo(X),
        E,
        handle(E)).

handle(a(Msg)) :-
    format('~w~n', Msg),
    !.
handle(X) :- throw(X).
