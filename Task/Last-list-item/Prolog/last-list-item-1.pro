%!  last_list_item(+List, -Last) is det.
last_list_item(List, Last) :-
    msort(List, Sorted),
    ignore(( debugging(last_list_item), writeln('List' = Sorted) )),
    last_list_item_(Sorted, Last).

last_list_item_([Last], Last) :- !.
last_list_item_([X, Y | List0], Last) :-
    Z is X + Y,
    msort([Z | List0], List),
    ignore(( debugging(last_list_item), writeln('List' = List) )),
    last_list_item_(List, Last).
