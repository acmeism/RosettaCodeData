#ifelse is a vectorised version of the if/else flow controllers, similar to the C-style ternary operator.
 x <- sample(1:10, 10)
 ifelse(x > 5, x^2, 0)
