% Reference: https://en.wikipedia.org/wiki/Lah_number#Identities_and_relations

:- dynamic unsigned_lah_number_cache/3.

unsigned_lah_number(N, N, 1):-!.
unsigned_lah_number(_, 0, 0):-!.
unsigned_lah_number(N, K, 0):-
	K > N,
	!.
unsigned_lah_number(N, K, L):-
	unsigned_lah_number_cache(N, K, L),
	!.
unsigned_lah_number(N, K, L):-
	N1 is N - 1,
	K1 is K - 1,
	unsigned_lah_number(N1, K, L1),
	unsigned_lah_number(N1, K1, L2),
	!,
	L is (N1 + K) * L1 + L2,
	assertz(unsigned_lah_number_cache(N, K, L)).

print_unsigned_lah_numbers(N):-
	between(1, N, K),
	unsigned_lah_number(N, K, L),
	writef('%11r', [L]),
	fail.
print_unsigned_lah_numbers(_):-
	nl.

print_unsigned_lah_numbers:-
	between(1, 12, N),
	print_unsigned_lah_numbers(N),
	fail.
print_unsigned_lah_numbers.

max_unsigned_lah_number(N, Max):-
    aggregate_all(max(L), (between(1, N, K), unsigned_lah_number(N, K, L)), Max).

main:-
	writeln('Unsigned Lah numbers up to L(12,12):'),
	print_unsigned_lah_numbers,
	writeln('Maximum value of L(n,k) where n = 100:'),
	max_unsigned_lah_number(100, M),
	writeln(M).
