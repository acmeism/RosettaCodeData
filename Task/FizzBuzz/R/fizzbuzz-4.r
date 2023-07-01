x <- paste0(rep("", 100), rep(c("", "Fizz"), times = c(2, 1)), rep(c("", "Buzz"), times = c(4, 1)))
cat(ifelse(x == "", 1:100, x), sep = "\n")
