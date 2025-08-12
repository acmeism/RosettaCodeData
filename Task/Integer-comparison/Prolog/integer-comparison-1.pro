:- set_prolog_flag(double_quotes, chars).

println([]) :- write('\n').
println([Char | Chars]) :- write(Char), println(Chars).

my_compare(A, B) :-
    (   A < B
    ->  println("A is less than B")
    ;   A > B
    ->  println("A is greater than B")
    ;   % double equals is necessary if we want the predicate to fail if A or B is unbound
        A == B
    ->  println("A is equal to B")
    ).
