:- set_prolog_flag(double_quotes, chars).

println([]) :- write('\n').
println([Char | Chars]) :- write(Char), println(Chars).

:- S0 = "Hello, ",
   S1 = "world!",
   append(S0, S1, S),
   println(S).
