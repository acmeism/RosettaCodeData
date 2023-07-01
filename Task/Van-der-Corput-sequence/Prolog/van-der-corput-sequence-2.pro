% g(B,N,X):- consecutively generate in X the first N elements of the sequence based on {0, 1, ..., B}

g(_,N,[L|_]-_,X):- N > 1, atomic_list_concat(['0.'|L],X).
g(B,N,[L|Ls]-Xs,X):- N > 2, M is N-1, findall([I|L], between(0,B,I), T), append(T,Ys,Xs), g(B,M,Ls-Ys,X).
g(_,N,'0.0'):- N > 0.
g(B,N,X):- N > 0, findall([I], between(1,B,I), T), T \= [], append(T,Ys,Xs), g(B,N,Xs-Ys,X).
