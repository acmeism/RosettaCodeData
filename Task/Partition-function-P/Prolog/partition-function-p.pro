/* SWI-Prolog 8.3.21 */
/* Author: Jan Burse */
:- table p/2.
p(0, 1) :- !.
p(N, X) :-
    aggregate_all(sum(Z), (between(1,inf,K), M is K*(3*K-1)//2,
           (M>N, !, fail; L is N-M, p(L,Y), Z is (-1)^K*Y)), A),
    aggregate_all(sum(Z), (between(1,inf,K), M is K*(3*K+1)//2,
           (M>N, !, fail; L is N-M, p(L,Y), Z is (-1)^K*Y)), B),
    X is -A-B.

?- time(p(6666,X)).
% 13,962,294 inferences, 2.610 CPU in 2.743 seconds (95% CPU, 5350059 Lips)
X = 1936553061617076610800050733944860919984809503384
05932486880600467114423441282418165863.
