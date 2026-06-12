print(sum(Filter(function(n) sum(as.integer(strsplit(as.character(n), "")[[1]])^5) == n, 2:(6*9^5))))

