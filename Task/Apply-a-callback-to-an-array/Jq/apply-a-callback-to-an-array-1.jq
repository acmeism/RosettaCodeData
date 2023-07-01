# Illustration of map/1 using the builtin filter: exp
map(exp)  # exponentiate each item in the input list

# A compound expression can be specified as the argument to map, e.g.
map( (. * .) + sqrt ) # x*x + sqrt(x)

# The compound expression can also be a composition of filters, e.g.
map( sqrt|floor )     # the floor of the sqrt

# Array comprehension
reduce .[] as $n ([]; . + [ exp ])

# Elementwise operation
 [.[] + 1 ]   # add 1 to each element of the input array
