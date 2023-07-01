change.base <- function(n, base)
{
  ret <- integer(as.integer(logb(x=n, base=base))+1L)

  for (i in 1:length(ret))
  {
    ret[i] <- n %% base
    n <- n %/% base

  }

  return(ret)
}

sum.digits <- function(n, base=10)
{
  if (base < 2)
    stop("base must be at least 2")

  return(sum(change.base(n=n, base=base)))
}

sum.digits(1)
sum.digits(12345)
sum.digits(123045)
sum.digits(0xfe, 16)
sum.digits(0xf0e, 16)
