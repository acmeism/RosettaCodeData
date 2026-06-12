epsilon <- median(epsilons)
epsilon
# [1] 5.939024e-18

a <- 1.0
b <- epsilon
c <- -epsilon

# left-to-right summation
(a + b) + c
# [1] 1

# kahan summation
kahansum(c(a, b, c))
# [1] 1

# are they the same?
(a + b) + c == kahansum(c(a, b, c))
# TRUE
