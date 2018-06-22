sub is-perf($n) { $n == [+] grep $n %% *, 1 .. $n div 2 }

# used as
put (grep {.&is-perf}, 1..Inf)[^4];
