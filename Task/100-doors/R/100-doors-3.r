doors_puzzle <- function(ndoors=100,passes=100) {
names(which(table(unlist(sapply(1:passes, function(X) seq(0, ndoors, by=X)))) %% 2 == 1))
}

doors_puzzle()
