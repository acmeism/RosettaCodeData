:- object(set).

    :- public(powerset/2).

    powerset(Set, PowerSet) :-
        reverse(Set, RSet),
        powerset_1(RSet, [[]], PowerSet).

    powerset_1([], PowerSet, PowerSet).
    powerset_1([X| Xs], Yss0, Yss) :-
        powerset_2(Yss0, X, Yss1),
        powerset_1(Xs, Yss1, Yss).

    powerset_2([], _, []).
    powerset_2([Zs| Zss], X, [Zs, [X| Zs]| Yss]) :-
        powerset_2(Zss, X, Yss).

    reverse(List, Reversed) :-
        reverse(List, [], Reversed).

    reverse([], Reversed, Reversed).
    reverse([Head| Tail], List, Reversed) :-
        reverse(Tail, [Head| List], Reversed).

:- end_object.
