sub is-perf($n) { $n == [+] grep $n %% *, 1 .. $n div 2 }

# used as
put ((1..Inf).hyper.grep: {.&is-perf})[^4];
