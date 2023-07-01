:- dynamic stirling2_cache/3.

stirling2(N, N, 1):-!.
stirling2(_, 0, 0):-!.
stirling2(N, K, 0):-
	K > N,
	!.
stirling2(N, K, L):-
	stirling2_cache(N, K, L),
	!.
stirling2(N, K, L):-
	N1 is N - 1,
	K1 is K - 1,
	stirling2(N1, K, L1),
	stirling2(N1, K1, L2),
	!,
	L is K * L1 + L2,
	assertz(stirling2_cache(N, K, L)).

print_stirling_numbers(N):-
	between(1, N, K),
	stirling2(N, K, L),
	writef('%8r', [L]),
	fail.
print_stirling_numbers(_):-
	nl.

print_stirling_numbers_up_to(M):-
	between(1, M, N),
	print_stirling_numbers(N),
	fail.
print_stirling_numbers_up_to(_).

max_stirling2(N, Max):-
    aggregate_all(max(L), (between(1, N, K), stirling2(N, K, L)), Max).

main:-
	writeln('Stirling numbers of the second kind up to S2(12,12):'),
	print_stirling_numbers_up_to(12),
	writeln('Maximum value of S2(n,k) where n = 100:'),
	max_stirling2(100, M),
	writeln(M).
