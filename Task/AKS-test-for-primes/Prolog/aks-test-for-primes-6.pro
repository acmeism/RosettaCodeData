%%% Task 4. Use your AKS test to generate a list of all primes under 35.

:-   prime(N), (N < 35 -> write(N), write(' '), fail ; nl).

% Output: 1 2 3 5 7 11 13 17 19 23 29 31

%%% Task 5. As a stretch goal, generate all primes under 50.

:-  prime(N), (N < 50 -> write(N), write(' '), fail ; nl).

% Output: 1 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47
