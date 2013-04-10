# As one can see from
getDLLRegisteredRoutines(getLoadedDLLs()$base)
# R knows functions bitwiseAnd, bitwiseOr, bitwiseXor and bitwiseNot.
# Here is how to call them (see ?.Call for the calling mechanism):

.Call("bitwiseOr",  as.integer(12), as.integer(10))
.Call("bitwiseXor", as.integer(12), as.integer(10))
.Call("bitwiseAnd", as.integer(12), as.integer(10))
.Call("bitwiseNot", as.integer(12))

# It would be easy to embed these calls in R functions, for better readability
# Also, it's possible to call these functions on integer vectors:

.Call("bitwiseOr", c(5L, 2L), c(3L, 8L))
