% SWI-Prolog:

?- time( (sieve(100000,P), length(P,N), writeln(N), last(P, LP), writeln(LP) )).
% 1,323,159 inferences, 0.862 CPU in 0.921 seconds (94% CPU, 1534724 Lips)
P = [2, 3, 5, 7, 11, 13, 17, 19, 23|...],
N = 9592,
LP = 99991.
