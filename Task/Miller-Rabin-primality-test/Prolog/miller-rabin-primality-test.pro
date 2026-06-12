:- module(primality, [is_prime/2]).

% is_prime/2 returns false if N is composite, true if N probably prime
%    implements a Miller-Rabin primality test and is deterministic for N < 3.415e+14,
%    and is probabilistic for larger N. Adapted from the Erlang version.
is_prime(1, Ret) :- Ret = false, !.          % 1 is non-prime
is_prime(2, Ret) :- Ret = true, !.           % 2 is prime
is_prime(3, Ret) :- Ret = true, !.           % 3 is prime
is_prime(N, Ret) :-
	N > 3, (N mod 2 =:= 0), Ret = false, !.  % even number > 3 is composite
is_prime(N, Ret) :-
	N > 3, (N mod 2 =:= 1),                  % odd number > 3
	N < 341550071728321,
	deterministic_witnesses(N, L),
 	is_mr_prime(N, L, Ret), !.               % deterministic test
is_prime(N, Ret) :-
	random_witnesses(N, 100, [], Out),
	is_mr_prime(N, Out, Ret), !.             % probabilistic test

% returns list of deterministic witnesses
deterministic_witnesses(N, L) :- N < 1373653,
	L = [2, 3].
deterministic_witnesses(N, L) :- N < 9080191,
	L = [31, 73].
deterministic_witnesses(N, L) :- N < 25326001,
	L = [2, 3, 5].
deterministic_witnesses(N, L) :- N < 3215031751,
	L = [2, 3, 5, 7].
deterministic_witnesses(N, L) :- N < 4759123141,
	L = [2, 7, 61].
deterministic_witnesses(N, L) :- N < 1122004669633,
	L = [2, 13, 23, 1662803].
deterministic_witnesses(N, L) :- N < 2152302898747,
	L = [2, 3, 5, 7, 11].
deterministic_witnesses(N, L) :- N < 3474749660383,
	L = [2, 3, 5, 7, 11, 13].
deterministic_witnesses(N, L) :- N < 341550071728321,
	L = [2, 3, 5, 7, 11, 13, 17].

% random_witnesses/4 returns a list of K witnesses selected at random with range 2 -> N-2
random_witnesses(_, 0, T, T).
random_witnesses(N, K, T, Out) :-
		G is N - 2,
		H is 1 + random(G),
		I is K - 1,
    	random_witnesses(N, I, [H | T], Out), !.

% find_ds/2 receives odd integer N and returns [D, S] s.t. N-1 = 2^S * D
find_ds(N, L) :-
	A is N - 1,
    find_ds(A, 0, L), !.

find_ds(D, S, L) :-
	D mod 2 =:= 0,
	P is D // 2,
	Q is S + 1,
	find_ds(P, Q, L), !.
find_ds(D, S, L) :-
	L = [D, S].

is_mr_prime(N, As, Ret) :-
    find_ds(N, L),
    L = [D | T],
    T = [S | _],
    outer_loop(N, As, D, S, Ret), !.

outer_loop(N, As, D, S, Ret) :-
    As = [A | At],
    Base is powm(A, D, N),
    inner_loop(Base, N, 0, S, Result),
	(  Result == false           -> Ret = false
	;  Result == true, At == []  -> Ret = true
	;  outer_loop(N, At, D, S, Ret)
	).

inner_loop(Base, N, Loop, S, Result) :-
    Next_Base is (Base * Base) mod N,
    Next_Loop is Loop + 1,
	( Loop =:= 0, Base =:= 1   -> Result = true
	;             Base =:= N-1 -> Result = true
	; Next_Loop =:= S          -> Result = false
	; inner_loop(Next_Base, N, Next_Loop, S, Result)
	).
