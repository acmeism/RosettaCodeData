# Since R 3.0.0, the base package provides bitwise operators, see ?bitwAnd

a <- 35
b <- 42
bitwAnd(a, b)
bitwOr(a, b)
bitwXor(a, b)
bitwNot(a)
bitwShiftL(a, 2)
bitwShiftR(a, 2)

# See also http://cran.r-project.org/src/base/NEWS.html
