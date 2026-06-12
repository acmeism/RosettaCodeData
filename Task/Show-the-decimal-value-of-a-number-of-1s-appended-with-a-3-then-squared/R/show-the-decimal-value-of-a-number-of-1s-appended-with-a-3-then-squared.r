as.numeric(Reduce(paste0, rep(1, 7), 3, right=TRUE, accumulate=TRUE))^2 |> rev() |> print(digits=14)
