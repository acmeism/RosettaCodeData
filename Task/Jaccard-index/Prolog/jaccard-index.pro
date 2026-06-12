show([]).
show([X|Xs]):- write(X), show(Xs).

j(N,M,X):- M > 0 -> X is N/M; X is 1.

task:- L = [[], [1,2,3,4,5], [1,3,5,7,9], [2,4,6,8,10], [2,3,5,7], [8]],
    forall((member(A,L), member(B,L)), (
        findall(X, (member(X,A), member(X,B)), I), length(I,N),
        findall(X, (member(X,B), not(member(X,A))), T), append(A,T,U), length(U,M),
        j(N,M,J), show(["A = ",A,", B = ",B,", J = ",J]), nl)).
