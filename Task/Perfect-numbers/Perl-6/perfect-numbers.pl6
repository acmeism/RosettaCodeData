sub perf($n) { $n == [+] grep $n %% *, 1 .. $n div 2 }
