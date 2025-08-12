my_compare2(A, B) :-
    compare(Order, A, B),
    my_compare2_(Order).

my_compare2_(<) :- println("A is less than B.").
my_compare2_(=) :- println("A is equal to B.").
my_compare2_(>) :- println("A is greater than B.").
