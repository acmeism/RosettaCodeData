% To generate the n-th row of a Pascal triangle
% pascal(+N, Row)
pascal(0, [1]).
pascal(N, Row) :-
  N > 0, optpascal( [1, N|Xs] ),
  !,
  pascalize( [1, N|Xs], Row ).

pascalize( Opt, Row ) :-
  % if Opt ends in a pair, then peel off the pair:
  ( append(X, [R,R], Opt) -> true ; append(X, [R], Opt) ),
  reverse(X, Rs),
  append( Opt, Rs, Row ).

% optpascal(-X) generates optpascal lines:
optpascal(X) :-
  optpascal_successor( [], X).

% optpascal_successor(+P, -Q) is true if Q is an optpascal list beneath the optpascal list P:
optpascal_successor(P, Q) :-
  optpascal(P, NextP),
  (Q = NextP ; optpascal_successor(NextP, Q)).

% optpascal(+Row, NextRow) is true if Row and NextRow are adjacent rows in the Pascal triangle.
% optpascal(+Row, NextRow) where the optpascal representation is used
optpascal(X, [1|Y]) :-
  add_pairs(X, Y).

% add_pairs(+OptPascal, NextOptPascal) is a helper function for optpascal/2.
% Given one OptPascal list, it generates the next by adding adjacent
% items, but if the last two items are unequal, then their sum is
% repeated.  This is intended to be a deterministic predicate, and to
% avoid a probable compiler limitation, we therefore use one cut.
add_pairs([], []).
add_pairs([X], [X]).
add_pairs([X,Y], Ans) :-
  S is X + Y,
  (X = Y -> Ans=[S] ; Ans=[S,S]),
  !.  % To overcome potential limitation of compiler

add_pairs( [X1, X2, X3|Xs], [S|Ys]) :-
  S is X1 + X2,
  add_pairs( [X2, X3|Xs], Ys).
