:- use_module(library(simplex)).

knapsack  :-
	L = [
	     (map, 	9, 	150),
	     (compass, 	13, 	35),
	     (water, 	153, 	200),
	     (sandwich, 50, 	160),
	     (glucose, 	15, 	60),
	     (tin, 	68, 	45),
	     (banana, 	27, 	60),
	     (apple, 	39, 	40),
	     (cheese, 	23, 	30),
	     (beer, 	52, 	10),
	     ('suntan cream', 	11, 	70),
	     (camera, 	32, 	30),
	     ('t-shirt', 	24, 	15),
	     (trousers, 48, 	10),
	     (umbrella, 73, 	40),
	     ('waterproof trousers', 	42, 	70),
	     ('waterproof overclothes', 	43, 	75),
	     ('note-case',22, 	80),
	     (sunglasses, 	7, 	20),
	     (towel, 	18, 	12),
	     (socks, 	4, 	50),
	     (book, 	30, 	10 )],
	 gen_state(S0),
	 length(L, N),
	 numlist(1, N, LN),
	 time(( create_constraint_N(LN, S0, S1),
		maplist(create_constraint_WV, LN, L, LW, LV),
		constraint(LW =< 400, S1, S2),
		maximize(LV, S2, S3)
	      )),
	compute_lenword(L, 0, Len),
	sformat(A1, '~~w~~t~~~w|', [Len]),
	sformat(A2, '~~t~~w~~~w|', [4]),
	sformat(A3, '~~t~~w~~~w|', [5]),
	print_results(S3, A1,A2,A3, L, LN, 0, 0).


create_constraint_N([], S, S).

create_constraint_N([HN|TN], S1, SF) :-
	constraint(integral(x(HN)), S1, S2),
	constraint([x(HN)] =< 1, S2, S3),
	constraint([x(HN)] >= 0, S3, S4),
	create_constraint_N(TN, S4, SF).

create_constraint_WV(N, (_, W, V), W * x(N), V * x(N)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
compute_lenword([], N, N).
compute_lenword([(Name, _, _)|T], N, NF):-
	atom_length(Name, L),
	(   L > N -> N1 = L; N1 = N),
	compute_lenword(T, N1, NF).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
print_results(_S, A1, A2, A3, [], [], WM, VM) :-
	sformat(W1, A1, [' ']),
	sformat(W2, A2, [WM]),
	sformat(W3, A3, [VM]),
	format('~w~w~w~n', [W1,W2,W3]).


print_results(S, A1, A2, A3, [(Name, W, V)|T], [N|TN], W1, V1) :-
	variable_value(S, x(N), X),
	(   X = 0 -> W1 = W2, V1 = V2
	;   sformat(S1, A1, [Name]),
	    sformat(S2, A2, [W]),
	    sformat(S3, A3, [V]),
	    format('~w~w~w~n', [S1,S2,S3]),
	    W2 is W1 + W,
	    V2 is V1 + V),
	print_results(S, A1, A2, A3, T, TN, W2, V2).
