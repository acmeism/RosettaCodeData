:- object(folding_examples).

    :- public(show/0).
    show :-
        integer::sequence(1, 10, List),
        write('List: '), write(List), nl,
        meta::fold_left([Acc,N,Sum0]>>(Sum0 is Acc+N), 0, List, Sum),
        write('Sum of all elements: '), write(Sum), nl,
        meta::fold_left([Acc,N,Product0]>>(Product0 is Acc*N), 1, List, Product),
        write('Product of all elements: '), write(Product), nl,
        meta::fold_left([Acc,N,Concat0]>>(number_codes(N,NC), atom_codes(NA,NC), atom_concat(Acc,NA,Concat0)), '', List, Concat),
        write('Concatenation of all elements: '), write(Concat), nl.

:- end_object.
