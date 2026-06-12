:- use_module(library(heaps)).
last_list_item_heap(List, Last) :-
    pairs_keys(Pairs, List),
    list_to_heap(Pairs, Heap),
    last_list_item_heap_(Heap, Last).

last_list_item_heap_(Heap0, Last) :-
    get_from_heap(Heap0, Value0, _, Heap1),
    (   get_from_heap(Heap1, Value1, _, Heap2)
    ->  Value is Value0 + Value1,
        ignore(( debugging(last_list_item_heap), writeln(Value is Value0 + Value1) )),
        add_to_heap(Heap2, Value, _, Heap),
        last_list_item_heap_(Heap, Last)
    ;   Value0 = Last
    ).
