# an implementation of the Kahan summation algorithm
kahansum <- function(x) {
    ks <- 0
    c <- 0
    for(i in 1:length(x)) {
        y <- x[i] - c
        kt <- ks + y
        c = (kt - ks) - y
        ks = kt
    }
    ks
}

# The three numbers a, b, c equal to 10000.0, 3.14159, 2.71828 respectively.
a <- 10000.0
b <- 3.14159
c <- 2.71828

# just to make sure, let's look at the classes of these three numbers
sapply(c(a, b, c), FUN=Class)
# [1] "numeric" "numeric" "numeric"

# The simple left-to-right summation: (a + b) + c
(a + b) + c
# [1] 10005.86

# The Kahan summation applied to the values a, b, c
input <- c(a, b, c)
kahansum(input)
# [1] 10005.86
