m(X,Y):- Y is X*(X*X+1)/2.

l(L,R,T,X):- L > R -> X is L; M is div(L+R,2), m(M,F),
    (T < F -> R_ is M-1, l(L,R_,T,X); L_ is M+1, l(L_,R,T,X)).
l(B,X):- l(1,B,B,X).

task:-
    write("First 20 magic constants are:"), forall(between(3,22,N), (m(N,X), format(" ~d",X))), nl,
    write("The 1000th magic constant is:"), forall(m(1002,X), format(" ~d",X)), nl,
    forall(between(1,20,N), (l(10**N,X), format("10^~d:\t~d\n",[N,X]))).
