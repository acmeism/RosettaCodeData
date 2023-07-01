flist(S) :- for(X, 0, S), female(X, R), format('~d ', [R]), fail.
mlist(S) :- for(X, 0, S), male(X, R), format('~d ', [R]), fail.
