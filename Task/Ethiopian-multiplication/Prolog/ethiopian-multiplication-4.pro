:- module(ethiopia, [test/0, mul/3]).

:- use_module(library(chr)).

:- chr_constraint mul/3, even/1, add_if_odd/4.

mul(1, Y, S) <=>          S = Y.
mul(X, Y, S) <=> X \= 1 | X1 is X // 2,
                          Y1 is Y * 2,
                          mul(X1, Y1, S1),
                          add_if_odd(X, Y, S1, S).

even(X) <=> 0 is X mod 2 | true.
even(X) <=> 1 is X mod 2 | false.

add_if_odd(X, _, A, S) <=> even(X)    | S is A.
add_if_odd(X, Y, A, S) <=> \+ even(X) | S is A + Y.

test :-
    mul(17, 34, Z),
    writeln(Z).
