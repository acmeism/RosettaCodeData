`%^%` <- function(mat, n)
{
  is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) abs(x - round(x)) < tol#See the docs for is.integer
  if(is.matrix(mat) && is.numeric(n) && is.wholenumber(n))
  {
    if(n==0) diag(nrow = nrow(mat))#Identity matrix of mat's dimensions
    else if(n == 1) mat
    else if(n > 1) mat %*% (mat %^% (n - 1))
    else stop("Invalid n.")
  }
  else stop("Invalid input type.")
}
#For output:
a %^% 0
a %^% 1
a %^% 2
a %*% a %*% a#Base R's equivalent of a %^% 3
a %^% 3
nonSquareMatrix <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3)
nonSquareMatrix %^% 1
nonSquareMatrix %^% 2#R's %*% will throw the error for us
