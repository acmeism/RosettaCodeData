sapply(1:100, function(n) sum(c(Filter(function(x) n %% x == 0, seq_len(n %/% 2)), n)))
