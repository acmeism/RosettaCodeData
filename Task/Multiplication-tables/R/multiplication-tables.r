multiplication_table <- function(n=12)
{
   one_to_n <- 1:n
   x <- matrix(one_to_n) %*% t(one_to_n)
   x[lower.tri(x)] <- 0
   rownames(x) <- colnames(x) <- one_to_n
   print(as.table(x), zero.print="")
   invisible(x)
}
multiplication_table()
