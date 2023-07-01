:- module(ethiopia, [test/0, mul/3]).

:- use_module(library(chr)).

:- chr_constraint mul/3, halve/2, double/2, even/1, add_odd/4.

mul(1, Y, S) <=>          S = Y.
mul(X, Y, S) <=> X \= 1 | halve(X, X1),
                          double(Y, Y1),
                          mul(X1, Y1, S1),
                          add_odd(X, Y, S1, S).

halve(X, Y) <=> Y is X // 2.

double(X, Y) <=> Y is X * 2.

even(X) <=> 0 is X mod 2 | true.
even(X) <=> 1 is X mod 2 | false.

add_odd(X, _, A, S) <=> even(X)    | S is A.
add_odd(X, Y, A, S) <=> \+ even(X) | S is A + Y.

test :-
    mul(17, 34, Z), !,
    writeln(Z).
