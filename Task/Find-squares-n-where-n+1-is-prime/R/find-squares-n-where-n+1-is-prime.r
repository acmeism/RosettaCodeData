sp <- c(2, 3, 5, 7, 11, 13, 17, 23, 29, 31)
cat(Filter(function(x) x %in% sp || all(x %% sp != 0), (1:32)^2 + 1) - 1)
