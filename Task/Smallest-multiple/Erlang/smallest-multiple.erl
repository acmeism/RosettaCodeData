-module(euler_project_no_5).
-export([gcd/2, lcm/2, smallest_multiple/1, main/0]).

% Compute the greatest common divisor (GCD)
gcd(A, 0) -> A;
gcd(A, B) -> gcd(B, A rem B).

% Compute the least common multiple (LCM)
lcm(A, B) -> (A * B) div gcd(A, B).

% Compute the smallest multiple of numbers from 1 to N
smallest_multiple(N) -> helper(1, 2, N).

helper(Acc, I, N) when I > N -> Acc;
helper(Acc, I, N) -> helper(lcm(Acc, I), I + 1, N).

% Main function to print the result
main() ->
    io:format("The smallest multiple for all numbers from 1 to 20 = ~p~n", [smallest_multiple(20)]).
