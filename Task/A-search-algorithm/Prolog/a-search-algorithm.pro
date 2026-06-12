:- use_module(library(assoc)).
:- use_module(library(heaps)).

moore_neighbourhood(yx(Y0, X0), yx(Y, X)) :-
    between(-1, 1, XOff),
    X is X0 + XOff,
    between(-1, 1, YOff),
    Y is Y0 + YOff,
    once( XOff \= 0 ; YOff \= 0 ).

barriers([yx(2, 3), yx(2, 4), yx(2, 5), yx(3, 5), yx(4, 2), yx(4, 5),
          yx(5, 2), yx(5, 5), yx(6, 2), yx(6, 3), yx(6, 4), yx(6, 5)]).

astar_search(Start) :-
    barriers(Barriers),
    findall(Coord - MovementCost, (
        between(0, 7, Y),
        between(0, 7, X),
        Coord = yx(Y, X),
        (   ord_memberchk(Coord, Barriers)
        ->  MovementCost = 100
        ;   MovementCost = 1
        )
    ), Pairs),
    ord_list_to_assoc(Pairs, Assoc),
    singleton_heap(Heap, 7, [Start] - 0),
    astar_search(Assoc, Heap, Result),
    display(Assoc, Result).

astar_search(Assoc0, Heap0, Result) :-
    get_from_heap(Heap0, _, [Here | Path] - Length0, Heap1),
    (   Here = yx(7, 7)
    ->  Result = [Here | Path] - Length0
    ;   del_assoc(Here, Assoc0, _, Assoc)
    ->  findall([There, Here | Path] - Length, (
            moore_neighbourhood(Here, There),
            get_assoc(There, Assoc, Length1),
            Length is Length0 + Length1
        ), NextSteps),
        foldl([S, H0, H] >> (
            S = [yx(Y, X) | _] - L,
            Heuristic is max(abs(7 - Y), abs(7 - X)) + L,
            add_to_heap(H0, Heuristic, S, H)
        ), NextSteps, Heap1, Heap),
        astar_search(Assoc, Heap, Result)
    ;   astar_search(Assoc0, Heap1, Result)
    ).

display(Assoc, Path - Length) :-
    format("Optimal path length: ~d~n", [Length]),
    writeln(Path),
    nl,
    foreach(( between(0, 7, Y), between(0, 7, X), Here = yx(Y, X) ), (
        (   memberchk(Here, Path)
        ->  write('O')
        ;   get_assoc(Here, Assoc, 100)
        ->  write('#')
        ;   write('.')
        ),
        (   X = 7
        ->  nl
        ;   true
        )
    )).
