:- dynamic array/2.

run :-
    write('Enter two positive integers, separated by a comma: '),
    read((I,J)),
    assert(array(I,J)),
    Value is I * J,
    format('a(~w,~w) = ~w', [I, J, Value]),
    retractall(array(_,_)).
