:- object(sieve).

	:- public(primes/2).

	:- coinductive([
		sieve/2, filter/3
	]).

	% computes a coinductive list with all the primes in the 2..N interval
	primes(N, Primes) :-
		generate_infinite_list(N, List),
		sieve(List, Primes).

	% generate a coinductive list with a 2..N repeating patern
	generate_infinite_list(N, List) :-
		sequence(2, N, List, List).

	sequence(Sup, Sup, [Sup| List], List) :-
		!.
	sequence(Inf, Sup, [Inf| List], Tail) :-
		Next is Inf + 1,
		sequence(Next, Sup, List, Tail).

	sieve([H| T], [H| R]) :-
		filter(H, T, F),
		sieve(F, R).

	filter(H, [K| T], L) :-
		(	K > H, K mod H =:= 0 ->
			% throw away the multiple we found
			L = T1
		;	% we must not throw away the integer used for filtering
			% as we must return a filtered coinductive list
			L = [K| T1]
		),
		filter(H, T, T1).

:- end_object.
