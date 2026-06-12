gosper <- function(x){
  C <- bitwAnd(x, -x)
  r <- x+C
  bitwOr(bitwShiftR(bitwXor(r, x), 2L)/C, r)
}

gosper10 <- function(x) Reduce(function(x,f) f(x),
                               rep(list(gosper), 10),
                               init=x,
                               accumulate=TRUE)
nums <- c(1,3,7,15)
setNames(lapply(nums, gosper10), nums)
