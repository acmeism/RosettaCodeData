x <- paste(rep("", 100), c("", "", "Fizz"), c("", "", "", "", "Buzz"), sep="")
cat(ifelse(x == "", 1:100, x), "\n")
