:- initialization(main).
main :- clause(less_than(1,2),B),writeln(B).
less_than(A,B) :- A<B.
