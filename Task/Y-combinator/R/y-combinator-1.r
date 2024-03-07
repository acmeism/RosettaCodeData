#' Y = λf.(λs.ss)(λx.f(xx))
#' Z = λf.(λs.ss)(λx.f(λz.(xx)z))
#'

fixp.Y <- \ (f) (\ (x) (x) (x)) (\ (y) (f) ((y) (y))) # y-combinator
fixp.Z <- \ (f) (\ (x) (x) (x)) (\ (y) (f) (\ (...) (y) (y) (...))) # z-combinator
