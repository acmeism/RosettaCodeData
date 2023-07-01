:- object(pascals).

    :- uses(integer, [plus/3, succ/2]).

    :- public(reset/0).

    reset :-
        retractall(triangle_(_,_,_)).

    :- private(triangle_/3).
    :- dynamic(triangle_/3).

    :- public(triangle/2).

    triangle(N, Lines) :-
        triangle(N, _, DiffLines),
        difflist::as_list(DiffLines, Lines).

    % Shortcut with cached value if it exists.
    triangle(N, Line, DiffLines) :- triangle_(N, Line, DiffLines), !.

    triangle(N, Line, DiffLines) :-
        succ(N0, N),
        triangle(N0, Line0, DiffLines0),
        ZL = [0|Line0],
        list::append(Line0, [0], ZR),
        meta::map(plus, ZL, ZR, Line),
        difflist::add(Line, DiffLines0, DiffLines),
        asserta(triangle_(N, Line, DiffLines)).

    triangle(1, [1], [[1]|X]-X).

:- end_object.
