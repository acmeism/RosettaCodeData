:- object(test_triangle).

    :- uses(integer, [between/3]).
    :- uses(list,    [length/2, member/2, sort/3, take/3]).
    :- uses(logtalk, [print_message(information, heronian, Message) as print(Message)]).

    :- public(start/0).

    start :-

        gather_primitive_heronians(Primitives),
        length(Primitives, L),
        print('There are ~w primitive Heronian triangles with sides under 200.~n'+[L]),

        sort(order_by(area), Primitives, AreaSorted),
        take(10, AreaSorted, Area10),
        print(@'The first ten found, ordered by area, are:\n'),
        display_each_element(Area10),

        sort(order_by(perimeter), Primitives, PerimeterSorted),
        take(10, PerimeterSorted, Perimeter10),
        print(@'The first ten found, ordered by perimeter, are:\n'),
        display_each_element(Perimeter10),

        findall(
            t(A, B, C, 210.0, Perimeter),
            member(t(A, B, C, 210.0, Perimeter), Primitives),
            Area210
        ),
        print(@'The list of those with an area of 210 is:\n'),
        display_each_element(Area210).

    % localized helper predicates

    % display a single element in the provided format
    display_single_element(t(A,B,C,Area,Perimeter)) :-
        format(F),
        print(F+[A, B, C, Area, Perimeter]).

    % display each element in a list of elements, printing a header first
    display_each_element(L) :-
        print(@' A   B   C    Area  Perimeter'),
        print(@'=== === === ======= ========='),
        forall(member(T, L), display_single_element(T)),
        print(@'\n').

    format('~|~` t~w~3+~` t~w~4+~` t~w~4+~` t~w~8+~` t~w~7+').

    % collect all the primitive heronian triangles within the boundaries of the provided task
    gather_primitive_heronians(Primitives) :-
        findall(
            t(A, B, C, Area, Perimeter),
            (
                between(3, 200, A),
                between(A, 200, B),
                between(B, 200, C),
                triangle(A, B, C)::primitive,
                triangle(A, B, C)::area(Area),
                triangle(A, B, C)::perimeter(Perimeter)
            ),
            Primitives
        ).

    order_by(_,         =, T,                     T)                     :- !.
    order_by(area,      <, t(_,_,_,Area1,_),      t(_,_,_,Area2,_))      :- Area1 < Area2, !.
    order_by(area,      >, t(_,_,_,Area1,_),      t(_,_,_,Area2,_))      :- Area1 > Area2, !.
    order_by(perimeter, <, t(_,_,_,_,Perimeter1), t(_,_,_,_,Perimeter2)) :- Perimeter1 < Perimeter2, !.
    order_by(perimeter, >, t(_,_,_,_,Perimeter1), t(_,_,_,_,Perimeter2)) :- Perimeter1 > Perimeter2, !.
    order_by(_,         <, t(A1,_,_,_,_),         t(A2,_,_,_,_))         :- A1 < A2, !.
    order_by(_,         <, t(_,B1,_,_,_),         t(_,B2,_,_,_))         :- B1 < B2, !.
    order_by(_,         <, t(_,_,C1,_,_),         t(_,_,C2,_,_))         :- C1 < C2, !.
    order_by(_,         >, _,                     _).

:- end_object.
