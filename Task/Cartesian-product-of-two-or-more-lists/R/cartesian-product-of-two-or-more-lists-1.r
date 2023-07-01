one_w_many <- function(one, many) lapply(many, function(x) c(one,x))

# Let's define an infix operator to perform a cartesian product.

"%p%" <- function( a, b ) {
  p = c( sapply(a, function (x) one_w_many(x, b) ) )
  if (is.null(unlist(p))) list() else p}

display_prod <-
  function (xs) { for (x in xs) cat( paste(x, collapse=", "), "\n" ) }

fmt_vec <- function(v) sprintf("(%s)", paste(v, collapse=', '))

go <- function (...) {
  cat("\n", paste( sapply(list(...),fmt_vec), collapse=" * "), "\n")
  prod = Reduce( '%p%', list(...) )
  display_prod( prod ) }
