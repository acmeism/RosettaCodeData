longest_sequence :-
	seq(2, 100000, 1-[1], Len-V),
	format('For ~w sequence has ~w len ! ~n', [V, Len]).


% walk through 2 to 100000 and compute the length of the sequences
% memorize the longest
seq(N, Max, Len-V, Len-V) :- N is Max + 1, !.
seq(N, Max, CLen - CV, FLen - FV) :-
	len_seq(N, Len - N),
	(   Len > CLen -> Len1 = Len, V1 = [N]
	;   Len = CLen -> Len1 = Len, V1 = [N | CV]
	;   Len1 = CLen, V1 = CV),
	N1 is N+1,
	seq(N1, Max, Len1 - V1, FLen - FV).

% compute the len of the Hailstone sequence for a number
len_seq(N, Len - N) :-
	hailstone(N),
	findall(hailstone(X), find_chr_constraint(hailstone(X)), L),
	length(L, Len),
	clean.
