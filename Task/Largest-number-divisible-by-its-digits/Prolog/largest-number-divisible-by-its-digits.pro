%  Find the largest integer divisible by all it's digits, with no digit repeated.
%  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%  We go for a generic algorithm here.  Test for divisibility is done by
%  calculating the least common multiplier for all digits, and testing
%  whether a candidate can be divided by the LCM without remainder.
%
%  Instead of iterating numbers and checking whether the number has
%  repeating digits, it is more efficient to generate permutations of
%  digits and then convert to a number.  Doing it this way reduces search
%  space greatly.
%
% Notes:
%  For decimal numbers we could improve times by testing only numbers
%  of length 7 (since 5x2=10 and 0 is not one of our digits, and 9x2=18
%  which needs 2 digits to store), but that sort of logic does not
%  hold for hexadecimal numbers.
%  We could also explicitly eliminate odd numbers, but the double validity
%  check actually slows us down very slightly instead of speeding us up.

:- dynamic
	trial/1.       % temporarily store digit combinations here.
	
gcd(X, X, X).  % Calculate greatest common divisor
gcd(M, N, X) :- N > M, B is N-M, gcd(M,B,X).
gcd(M, N, X) :- N < M, A is M-N, gcd(A,N,X).

lcm(A, B, LCM) :- gcd(A,B,GCD), LCM is A * B / GCD.

lcm([H], H).   % Calculate least common multiplier
lcm([A|T], LCM) :- lcm(T, B), !, lcm(A,B,LCM).

mkint(_, Val, [], Val).     % Result = Val where list is empty
mkint(Radix, Val, [H|T], Int) :-  % (((I0*10+I1)*10+I2)*10+In)...
	V0 is Val*Radix+H, !, mkint(Radix, V0, T, Int).

% Turn a list of digits into an integer number using Radix.
mkint(Radix, [H|T], Int) :- mkint(Radix, H, T, Int).

domain(0, []).       % For example, domain(5) is [1,2,3,4,5]
domain(N, [N|Digits]) :-
   succ(N0, N), !, domain(N0, Digits).

trial(0, Digits, Digits).   % generates a combination of digits to test
trial(N, D, Digits) :-      % remove N digits, and find remaining combinations
    append(L0,[_|L1],D), succ(N0, N), trial(N0, L1, Dx),
    append(L0, Dx, Digits). % trial(1, [3,2,1], D) -> D=[2,1]; D=[3,1]; D=[3,2].

make_trials(_,_) :- retractall(trial(_)), fail.
make_trials(N,Domain) :- trial(N, Domain, Digits), asserta(trial(Digits)), fail.
make_trials(_,_).           % trials are stored highest values to lowest

combinations(Radix, NDigits) :-  % Precalculate all possible digit combinations
    succ(R0, Radix), domain(R0, Domain), Nskip is R0 - NDigits,
    make_trials(Nskip, Domain).

test(Radix, Digits, LCM, Number) :-  % Make an integer and check for divisibility
   mkint(Radix, Digits, Number), 0 is Number mod LCM.

bignum(Radix, Number) :-
   succ(R0, Radix), between(1,R0,N), NDigits is Radix - N,    % loop decreasing length
   combinations(Radix, NDigits),            % precalc digit combos with length=NDigits
   trial(Digits), lcm(Digits, LCM),         % for a combination, calculate LCM
   permutation(Digits, Trial),              % generate a permutation
   test(Radix, Trial, LCM, Number).         % test for divisibility

largest_decimal(N) :- bignum(10, N), !.
largest_hex(N, H) :- bignum(16, N), !, sformat(H, '~16r', [N]).
