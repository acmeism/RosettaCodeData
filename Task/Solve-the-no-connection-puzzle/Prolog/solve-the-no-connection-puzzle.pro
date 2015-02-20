:- use_module(library(clpfd)).

edge(a, c).
edge(a, d).
edge(a, e).
edge(b, d).
edge(b, e).
edge(b, f).
edge(c, d).
edge(c, g).
edge(d, e).
edge(d, g).
edge(d, h).
edge(e, f).
edge(e, g).
edge(e, h).
edge(f, h).

connected(A, B) :-
	(   edge(A,B); edge(B, A)).

no_connection_puzzle(Vs) :-
	% construct the arranged list of the nodes
	bagof(A, B^(edge(A,B); edge(B, A)), Lst),
	sort(Lst, L),
	length(L, Len),

	% construct the list of the values
	length(Vs, Len),
	Vs ins 1..Len,
	all_distinct(Vs),

	% two connected nodes must have values different for more than 1
	set_constraints(L, Vs),
	label(Vs).


set_constraints([], []).

set_constraints([H | T], [VH | VT]) :-
	set_constraint(H, T, VH, VT),
	set_constraints(T, VT).



set_constraint(_, [], _, []).
set_constraint(H, [H1 | T1], V, [VH | VT]) :-
	connected(H, H1),
	(   V - VH #> 1; VH - V #> 1),
	set_constraint(H, T1, V, VT).

set_constraint(H, [H1 | T1], V, [_VH | VT]) :-
	\+connected(H, H1),
	set_constraint(H, T1, V, VT).
