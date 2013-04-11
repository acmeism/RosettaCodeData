is.square <- function(x)
{
   sqrx <- sqrt(x)
   err <- abs(sqrx - round(sqrx))
   err < 100*.Machine$double.eps
}
any(is.square(nonsqr(1:1e6)))
