los(["AA","BB","CC"]).
los(["AA","AA","AA"]).
los(["AA","CC","BB"]).
los(["AA","ACB","BB","CC"]).
los(["single_element"]).

lexically_equal(S,S,S).
in_order(G,L,G) :- compare(<,L,G).

test_list(List) :-
    List = [L|T],
    write('for list '), write(List), nl,
    (foldl(lexically_equal, T, L, _)
        -> writeln('The items in the list ARE lexically equal')
        ; writeln('The items in the list are NOT lexically equal')),
    (foldl(in_order, T, L, _)
        -> writeln('The items in the list ARE in ascending order')
        ; writeln('The items in the list are NOT in ascending order')),
    nl.

test :- forall(los(List), test_list(List)).
