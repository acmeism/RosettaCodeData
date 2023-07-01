% John Devou: 26-Nov-2021

% g(N,X):- consecutively generate in X the first N elements of the Calkin-Wilf sequence

g(N,[A/B|_]-_,A/B):- N > 0.
g(N,[A/B|Ls]-[A/C,C/B|Ys],X):- N > 1, M is N-1, C is A+B, g(M,Ls-Ys,X).
g(N,X):- g(N,[1/1|Ls]-Ls,X).

% t(A/B,X):- generate in X the index of A/B in the Calkin-Wilf sequence

t(A/1,S,C,X):- X is C*(2**(A-1+S)-S).
t(A/B,S,C,X):- B > 1, divmod(A,B,M,N), T is 1-S, D is C*2**M, t(B/N,T,D,Y), X is Y + S*C*(2**M-1).
t(A/B,X):- t(A/B,1,1,X), !.
