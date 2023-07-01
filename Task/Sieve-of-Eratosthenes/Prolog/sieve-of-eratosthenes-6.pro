primes(PS):- count(2, 1, NS), sieve(NS, PS).

count(N, D, [N|T]):- freeze(T, (N2 is N+D, count(N2, D, T))).

sieve([N|NS],[N|PS]):- N2 is N*N, count(N2,N,A), remove(A,NS,B), freeze(PS, sieve(B,PS)).

take(N, X, A):- length(A, N), append(A, _, X).

remove([A|T],[B|S],R):- A < B -> remove(T,[B|S],R) ;
                        A=:=B -> remove(T,S,R) ;
                        R = [B|R2], freeze(R2, remove([A|T], S, R2)).
