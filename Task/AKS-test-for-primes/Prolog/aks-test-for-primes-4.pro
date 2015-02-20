%%% Task 3. Use the previous function in creating [sic]
%%% another function that when given p returns whether p is prime
%%% using the AKS test.

% Even for testing whether a given number, N, is prime,
% this approach is inefficient, but here is a Prolog implementation:

   prime_test_per_requirements(N) :-
     coefficients(N, [1|Coefficients]),
     append(Cs, [_], Coefficients),
     forall( member(C, Cs), 0 is C mod N).
