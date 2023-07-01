% John Devou: 26-Nov-2021

d(_,_,[],[]).
d(N,N,[_|Xs],Rs):- d(N,1,Xs,Rs).
d(N,M,[X|Xs],[X|Rs]):- M < N, M_ is M+1, d(N,M_,Xs,Rs).

l([],[]).
l([X|Xs],[X|Rs]):- d(X,1,Xs,Ys), l(Ys,Rs).

% g(N,L):- generate in L a list with Ludic numbers up to N

g(N,[1|X]):- numlist(2,N,L), l(L,X).

s(0,Xs,[],Xs).
s(N,[X|Xs],[X|Ls],Rs):- N > 0, M is N-1, s(M,Xs,Ls,Rs).

t([X,Y,Z|_],[X,Y,Z]):- Y =:= X+2, Z =:= X+6.
t([_,Y,Z|Xs],R):- t([Y,Z|Xs],R).

% tasks

t1:- g(500,L), s(25,L,X,_), write(X), !.
t2:- g(1000,L), length(L,X), write(X), !.
t3:- g(22000,L), s(1999,L,_,R), s(6,R,X,_), write(X), !.
t4:- g(249,L), findall(A, t(L,A), X), write(X), !.
