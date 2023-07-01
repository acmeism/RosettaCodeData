x <- paste0(rep("", 100), c("", "", "Fizz"), c("", "", "", "", "Buzz"))
cat(ifelse(x == "", 1:100, x), sep = "\n")
