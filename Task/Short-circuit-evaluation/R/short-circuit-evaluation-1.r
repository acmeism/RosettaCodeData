a <- function(x) {cat("a called\n"); x}
b <- function(x) {cat("b called\n"); x}

tests <- expand.grid(op=list(quote(`||`), quote(`&&`)), x=c(1,0), y=c(1,0))

invisible(apply(tests, 1, function(row) {
  call <- substitute(op(a(x),b(y)), row)
  cat(deparse(call), "->", eval(call), "\n\n")
}))
