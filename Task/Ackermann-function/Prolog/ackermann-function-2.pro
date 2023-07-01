ack(0,N,s(N)).
ack(s(M),0,P):- ack(M,s(0),P).
ack(s(M),s(N),P):- ack(s(M),N,S), ack(M,S,P).

% Peano's first axiom in Prolog is that s(0) AND s(s(N)):- s(N)
% Thanks to this we don't need explicit N > 0 checks.
% Nor explicit arithmetic operations like X is M-1.
% Recursion and unification naturally decrement s(N) to N.
% But: Prolog clauses are relations and cannot be replaced by their result, like functions.
% Because of this we do need an extra argument to hold the output of the function.
% And we also need an additional call to the function in the last clause.

% Example input/output:
% ?- ack(s(0),s(s(0)),P).
% P = s(s(s(s(0)))) ;
% false.
