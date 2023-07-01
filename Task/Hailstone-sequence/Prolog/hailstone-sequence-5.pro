:- use_module(library(chr)).
:- chr_option(debug, off).
:- chr_option(optimize, full).

:- chr_constraint collatz/2, hailstone/1, clean/0.

% to remove all constraints hailstone/1 after computation
clean @ clean \ hailstone(_) <=> true.
clean @ clean <=> true.

% compute Collatz number
init @ collatz(1,X) <=>  X = 1 | true.
collatz @ collatz(N, C) <=> (N mod 2 =:= 0 -> C is N / 2; C is 3 * N + 1).

% Hailstone loop
hailstone(1) ==> true.
hailstone(N) ==> N \= 1 | collatz(N, H), hailstone(H).
