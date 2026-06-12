% Define the initial lists
list1([1,2,3,4,5,6,7,8,9]).
list2([10,11,12,13,14,15,16,17,18]).
list3([19,20,21,22,23,24,25,26,27]).

% Concatenate the elements of the lists
concat_lists([], [], [], []).
concat_lists([H1|T1], [H2|T2], [H3|T3], [H|T]) :-
    atom_concat(H1, H2, Tmp1),
    atom_concat(Tmp1, H3, Tmp),
    atom_number(Tmp, H),
    concat_lists(T1, T2, T3, T).

% Print the resulting list
print_list([]).
print_list([H|T]) :-
    write(H), write(' '),
    print_list(T).

% Main program
main :-
    list1(L1),
    list2(L2),
    list3(L3),
    concat_lists(L1, L2, L3, CatList),
    print_list(CatList).
