/*
* Nonogram/paint-by-numbers solver in SWI-Prolog. Uses CLP(FD),
* in particular the automaton/3 (finite-state/RE) constraint.
* Copyright (c) 2011 Lars Buitinck.
* Do with this code as you like, but don't remove the copyright notice.
*/

:- use_module(library(clpfd)).

nono(RowSpec, ColSpec, Grid) :-
	rows(RowSpec, Grid),
	transpose(Grid, GridT),
	rows(ColSpec, GridT).

rows([], []).
rows([C|Cs], [R|Rs]) :-
	row(C, R),
	rows(Cs, Rs).

row(Ks, Row) :-
	sum(Ks, #=, Ones),
	sum(Row, #=, Ones),
	arcs(Ks, Arcs, start, Final),
	append(Row, [0], RowZ),
	automaton(RowZ, [source(start), sink(Final)], [arc(start,0,start) | Arcs]).

% Make list of transition arcs for finite-state constraint.
arcs([], [], Final, Final).
arcs([K|Ks], Arcs, CurState, Final) :-
	gensym(state, NextState),
	(   K == 0
	->  Arcs = [arc(CurState,0,CurState), arc(CurState,0,NextState) | Rest],
	    arcs(Ks, Rest, NextState, Final)
	;   Arcs = [arc(CurState,1,NextState) | Rest],
	    K1 #= K-1,
	    arcs([K1|Ks], Rest, NextState, Final)).


make_grid(Grid, X, Y, Vars) :-
	length(Grid,X),
	make_rows(Grid, Y, Vars).

make_rows([], _, []).
make_rows([R|Rs], Len, Vars) :-
	length(R, Len),
	make_rows(Rs, Len, Vars0),
	append(R, Vars0, Vars).

print([]).
print([R|Rs]) :-
	print_row(R),
	print(Rs).

print_row([]) :- nl.
print_row([X|R]) :-
	(   X == 0
	->  write(' ')
	;   write('x')),
	print_row(R).

nonogram(Rows, Cols) :-
	length(Rows, X),
	length(Cols, Y),
	make_grid(Grid, X, Y, Vars),
	nono(Rows, Cols, Grid),
	label(Vars),
	print(Grid).
