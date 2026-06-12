(a + b) + c == kahansum(c(a, b, c))
# FALSE

# ok, then what is the difference?
((a + b) + c) - kahansum(c(a, b, c))
# [1] -1.110223e-16
