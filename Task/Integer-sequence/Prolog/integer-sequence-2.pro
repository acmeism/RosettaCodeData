:- use_module(library(chr)).

:- chr_constraint loop/1.

loop(N) <=> writeln(N), N1 is N+1, loop(N1).
