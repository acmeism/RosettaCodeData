d <- data.frame(a=c(2,4,6), b = c(5,7,9))
also <- c(1, 0, 2)
with(d, mean(b - a + also)) #returns 4

## with() is built in, but you might have implemented it like this:

with.impl <- function(env, expr) {
  env <- as.environment(env)
  parent.env(env) <- parent.frame()
  eval(substitute(expr), envir=env)
}
with.impl(d, mean(b - a + also))
