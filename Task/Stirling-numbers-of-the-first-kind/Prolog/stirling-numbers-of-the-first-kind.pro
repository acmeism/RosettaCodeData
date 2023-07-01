:- dynamic stirling1_cache/3.

stirling1(N, N, 1):-!.
stirling1(_, 0, 0):-!.
stirling1(N, K, 0):-
	K > N,
	!.
stirling1(N, K, L):-
	stirling1_cache(N, K, L),
	!.
stirling1(N, K, L):-
	N1 is N - 1,
	K1 is K - 1,
	stirling1(N1, K, L1),
	stirling1(N1, K1, L2),
	!,
	L is L2 + (N - 1) * L1,
	assertz(stirling1_cache(N, K, L)).

print_stirling_numbers(N):-
	between(1, N, K),
	stirling1(N, K, L),
	writef('%10r', [L]),
	fail.
print_stirling_numbers(_):-
	nl.

print_stirling_numbers_up_to(M):-
	between(1, M, N),
	print_stirling_numbers(N),
	fail.
print_stirling_numbers_up_to(_).

max_stirling1(N, Max):-
    aggregate_all(max(L), (between(1, N, K), stirling1(N, K, L)), Max).

main:-
	writeln('Unsigned Stirling numbers of the first kind up to S1(12,12):'),
	print_stirling_numbers_up_to(12),
	writeln('Maximum value of S1(n,k) where n = 100:'),
	max_stirling1(100, M),
	writeln(M).
