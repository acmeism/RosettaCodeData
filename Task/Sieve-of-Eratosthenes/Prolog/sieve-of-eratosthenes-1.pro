% %sieve( +N, -Primes ) is true if Primes is the list of consecutive primes
% that are less than or equal to N
sieve( N, [2|Rest]) :-
  retractall( composite(_) ),
  sieve( N, 2, Rest ) -> true.  % only one solution

% sieve P, find the next non-prime, and then recurse:
sieve( N, P, [I|Rest] ) :-
  sieve_once(P, N),
  (P = 2 -> P2 is P+1; P2 is P+2),
  between(P2, N, I),
  (composite(I) -> fail; sieve( N, I, Rest )).

% It is OK if there are no more primes less than or equal to N:
sieve( N, P, [] ).

sieve_once(P, N) :-
  forall( between(P, N, P, IP),
          (composite(IP) -> true ; assertz( composite(IP) )) ).


% To avoid division, we use the iterator
% between(+Min, +Max, +By, -I)
% where we assume that By > 0
% This is like "for(I=Min; I <= Max; I+=By)" in C.
between(Min, Max, By, I) :-
  Min =< Max,
  A is Min + By,
  (I = Min; between(A, Max, By, I) ).


% Some Prolog implementations require the dynamic predicates be
%  declared:

:- dynamic( composite/1 ).
