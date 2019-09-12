#lang R
library(Rmpfr)
prec <- 1000 # precision in bits
`%:%` <- function(e1, e2) '/'(mpfr(e1, prec), mpfr(e2, prec)) # operator %:% for high precision division
# function for checking identity of tan of expression and 1, making use of high precision division operator %:%
tanident_1 <- function(x) identical(round(tan(eval(parse(text = gsub("/", "%:%", deparse(substitute(x)))))), (prec/10)), mpfr(1, prec))
