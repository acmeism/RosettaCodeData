:- use_module(library(func)).

% halve/2, double/2, is_even/2 definitions go here

ethiopian(First,Second,Product) :-
    ethiopian(First,Second,0,Product).

ethiopian(1,Second,Sum0,Sum) :-
    Sum is Sum0 + Second.
ethiopian(First,Second,Sum0,Sum) :-
    Sum1 is Sum0 + Second*(First mod 2),
    ethiopian(halve $ First, double $ Second, Sum1, Sum).
