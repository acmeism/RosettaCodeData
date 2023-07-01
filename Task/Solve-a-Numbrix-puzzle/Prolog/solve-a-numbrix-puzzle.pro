/*
 * Solver
 */
solve([A|T]) :-
	numlist(1,81,S),
	select(A,S,R),
	solve_([A|T],R).

solve_([_],[]).
solve_([A,B|T],R) :-
	move(A,B),
	select(B,R,Rt),
	solve_([B|T],Rt).
	
move(A,B) :- lr(A,B) ; lr(B,A) ; ud(A,B) ; ud(B,A).

% create the left-right mapping rules at compile time
term_expansion(lr(0,0),LrList) :-
	findall(LR,
		(between(1,81,N), M is N mod 9, dif(M,0), succ(N,N1), LR = lr(N,N1)),
		LrList).
lr(0,0).

% create the up-down mapping rules at compile time
term_expansion(ud(0,0),UdList) :-
	findall(UD,
		(between(1,72,N), N9 is N + 9, UD = ud(N,N9)),
		UdList).
ud(0,0).


/*
 * Grid <-> Solvable List
 */
grid_solvable([],_,_).
grid_solvable([A|T],N,S) :-
	(integer(A) -> nth1(A,S,N);true),
	succ(N,N1),
	grid_solvable(T,N1,S).
	
solvable_grid([],_,_).
solvable_grid([A|T],N,G) :-
	nth1(A,G,N),
	succ(N,N1),
	solvable_grid(T,N1,G).


/*
 * Print Grid
 */
print_cell(C) :-
	C >= 10 -> format(' ~d', C)
	; format('  ~d', C).
print_grid([],_).
print_grid([C|T],N) :-
	print_cell(C),
	(0 is N mod 9 -> nl ; true),
	succ(N,N1),
	print_grid(T,N1).

	
/* 	
 * Numbrix!
 */
numbrix(L) :-
	length(S, 81),
	grid_solvable(L,1,S),
	solve(S),
	solvable_grid(S,1,P),
	print_grid(P,1),
	!.

test1 :- numbrix([
     _,  _,  _,  _,  _,  _,  _,  _,  _,
     _,  _, 46, 45,  _, 55, 74,  _,  _,
     _, 38,  _,  _, 43,  _,  _, 78,  _,
     _, 35,  _,  _,  _,  _,  _, 71,  _,
     _,  _, 33,  _,  _,  _, 59,  _,  _,
     _, 17,  _,  _,  _,  _,  _, 67,  _,
     _, 18,  _,  _, 11,  _,  _, 64,  _,
     _,  _, 24, 21,  _,  1,  2,  _,  _,
     _,  _,  _,  _,  _,  _,  _,  _,  _
]).

test2 :- numbrix([
     _,  _,  _,  _,  _,  _,  _,  _,  _,
     _, 11, 12, 15, 18, 21, 62, 61,  _,
     _,  6,  _,  _,  _,  _,  _, 60,  _,
     _, 33,  _,  _,  _,  _,  _, 57,  _,
     _, 32,  _,  _,  _,  _,  _, 56,  _,
     _, 37,  _,  1,  _,  _,  _, 73,  _,
     _, 38,  _,  _,  _,  _,  _, 72,  _,
     _, 43, 44, 47, 48, 51, 76, 77,  _,
     _,  _,  _,  _,  _,  _,  _,  _,  _
]).

test3 :- numbrix([
    17,  _,  _,  _, 11,  _,  _,  _, 59,
    _,  15,  _,  _,  6,  _,  _, 61,  _,
    _,   _,  3,  _,  _,  _, 63,  _,  _,
    _,   _,  _,  _, 66,  _,  _,  _,  _,
    23, 24,  _, 68, 67, 78,  _, 54, 55,
    _,   _,  _,  _, 72,  _,  _,  _,  _,
    _,   _, 35,  _,  _,  _, 49,  _,  _,
    _,  29,  _,  _, 40,  _,  _, 47,  _,
    31,  _,  _,  _, 39,  _,  _,  _, 45
]).
