:- use_module(library(clpfd)).

% tuples (name, weights, value, nb pieces).
knapsack :-
	L = [(   map, 	        9, 	150, 	1),
	     (   compass, 	13, 	35, 	1),
	     (   water, 	153, 	200, 	2),
	     (   sandwich, 	50, 	60, 	2),
	     (   glucose, 	15, 	60, 	2),
	     (   tin, 	68, 	45, 	3),
	     (   banana, 	27, 	60, 	3),
	     (   apple, 	39, 	40, 	3),
	     (   cheese, 	23, 	30, 	1),
	     (   beer, 	52, 	10, 	3),
	     (   'suntan cream', 	11, 	70, 	1),
	     (   camera, 	32, 	30, 	1),
	     (   'T-shirt', 	24, 	15, 	2),
	     (   trousers, 	48, 	10, 	2),
	     (   umbrella, 	73, 	40, 	1),
	     (   'waterproof trousers', 	42, 	70, 	1),
	     (   'waterproof overclothes', 	43, 	75, 	1),
	     (   'note-case', 	22, 	80, 	1),
	     (   sunglasses, 	7, 	20, 	1),
	     (   towel, 	18, 	12, 	2),
	     (   socks, 	4, 	50, 	1),
	     (   book, 	30, 	10, 	2)],

	% R is the list of the numbers of each items
	% these numbers are between 0 and the 4th value of the tuples of the items
	maplist(create_lists,L, R, LW, LV),
	sum(LW, #=<, 400),
	sum(LV, #=, VM),

	% to have statistics on the resolution of the problem.
	time(labeling([max(VM)], R)),
	sum(LW, #=, WM),

	%% displayinf of the results.
	compute_lenword(L, 0, Len),
	sformat(A1, '~~w~~t~~~w|', [Len]),
	sformat(A2, '~~t~~w~~~w|', [4]),
	sformat(A3, '~~t~~w~~~w|', [5]),
	print_results(A1,A2,A3, L, R, WM, VM).


create_lists((_, W, V, N), C, LW, LV) :-
	C in 0..N,
	LW #= C * W,
	LV #= C * V.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
compute_lenword([], N, N).
compute_lenword([(Name, _, _, _)|T], N, NF):-
	atom_length(Name, L),
	(   L > N -> N1 = L; N1 = N),
	compute_lenword(T, N1, NF).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
print_results(A1,A2,A3, [], [], WM, WR) :-
	sformat(W0, '~w ', [' ']),
	sformat(W1, A1, [' ']),
	sformat(W2, A2, [WM]),
	sformat(W3, A3, [WR]),
	format('~w~w~w~w~n', [W0,W1,W2,W3]).


print_results(A1,A2,A3, [_H|T], [0|TR], WM, VM) :-
	!,
	print_results(A1,A2,A3, T, TR, WM, VM).

print_results(A1, A2, A3, [(Name, W, V, _)|T], [N|TR], WM, VM) :-
	sformat(W0, '~w ', [N]),
	sformat(W1, A1, [Name]),
	sformat(W2, A2, [W]),
	sformat(W3, A3, [V]),
	format('~w~w~w~w~n', [W0,W1,W2,W3]),
	print_results(A1, A2, A3, T, TR, WM, VM).
