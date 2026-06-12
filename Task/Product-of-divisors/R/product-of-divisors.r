sapply(1:50, function(n) prod(c(Filter(function(x) n %% x == 0, seq_len(n %/% 2)), n)))
