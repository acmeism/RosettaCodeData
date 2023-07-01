sortbyname <- function(x, ...) x[order(names(x), ...)]
x <- c(texas=68.9, ohio=87.8, california=76.2, "new york"=88.2)
sortbyname(x)
