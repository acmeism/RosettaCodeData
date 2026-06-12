a <- 1.0
b <- epsilon
c <- -epsilon

# left-to-right summation
(a + b) + c
# [1] 1

# kahan summation
kahansum(c(a, b, c))
# [1] 1
