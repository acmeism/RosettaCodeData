nPrimes( M, Primes) :- nPrimes( [2], M, Primes).

nPrimes( Accumulator, I, Primes) :-
	next_prime(Accumulator, Prime),
	append(Accumulator, [Prime], Next),
	length(Next, N),
	( N = I -> Primes = Next; nPrimes( Next, I, Primes)).

% next_prime(+Primes, NextPrime) succeeds if NextPrime is the next
% prime after a list, Primes, of consecutive primes starting at 2.
next_prime([2], 3).
next_prime([2|Primes], P) :-
	last(Primes, PP),
	P2 is PP + 2,
	generate(P2, N),
	1 is N mod 2,		        % odd
	Max is floor(sqrt(N+1)),	% round-off paranoia
	forall( (member(Prime, [2|Primes]),
		 (Prime =< Max -> true
		 ; (!, fail))), N mod Prime > 0 ),
	!,
        P = N.

% multiply( +A, +List, Answer )
multiply( A, [], [] ).
multiply( A, [X|Xs], [AX|As] ) :-
  AX is A * X,
  multiply(A, Xs, As).

% multiplylist( L1, L2, List ) succeeds if List is the concatenation of X * L2
% for successive elements X of L1.
multiplylist( [], B, [] ).
multiplylist( [A|As], B, List ) :-
   multiply(A, B, L1),
   multiplylist(As, B, L2),
   append(L1, L2, List).

take(N, List, Head) :-
  length(Head, N),
  append(Head,X,List).
