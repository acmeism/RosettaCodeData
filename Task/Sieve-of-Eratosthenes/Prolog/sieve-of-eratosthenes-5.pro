primes(N,[]):- N < 2, !.
primes(N,[2|R]):- ints(3,N,L), sift(N,L,R).
ints(A,B,[A|C]):- A=<B -> D is A+2, ints(D,B,C).
ints(_,_,[]).
sift(_,[],[]).
sift(N,[A|B],[A|C]):- A*A =< N ->  rmv(A,B,D), sift(N,D,C)
                      ; C=B.
rmv(A,B,D):- M is A*A, rmv(A,M,B,D).
rmv(_,_,[],[]).
rmv(P,M,[A|B],C):- (   M>A ->  C=[A|D], rmv(P,M,B,D)
                   ;   M==A ->  M2 is M+2*P, rmv(P,M2,B,C)
                   ;   M<A ->  M2 is M+2*P, rmv(P,M2,[A|B],C)
                   ).
