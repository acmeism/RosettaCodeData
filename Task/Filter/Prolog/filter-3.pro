?- use_module(library(lambda)).
true.

?- include((\X^(X mod 2 =:= 0)), [1,2,3,4,5,6,7,8,9], L).
L = [2,4,6,8].
