powerset(X,Y) :- bagof( S, subseq(S,X), Y).

subseq( [], []).
subseq( [], [_|_]).
subseq( [X|Xs], [X|Ys] ) :- subseq(Xs, Ys).
subseq( [X|Xs], [_|Ys] ) :- append(_, [X|Zs], Ys), subseq(Xs, Zs).
