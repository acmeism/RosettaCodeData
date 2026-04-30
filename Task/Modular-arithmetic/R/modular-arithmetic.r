as.modular <- function(x, modulus){
  if(x<0|modulus<=0) stop("both arguments must be non-negative and modulus cannot be zero")
  if(!(is.integer(x)&is.integer(modulus))) stop("both arguments must be integers")
  if(x>=modulus) x <- x%%modulus
  structure(list("num"=x, "mod"=modulus), class="modular")
}

`+.modular` <- function(a, b){
  if(is.integer(b)) b <- as.modular(b, a$mod)
  if(a$mod!=b$mod) stop("arguments must have the same modulus")
  as.modular(a$num+b$num, a$mod)
}

`*.modular` <- function(a, b){
  if(is.integer(b)) b <- as.modular(b, a$mod)
  if(a$mod!=b$mod) stop("arguments must have the same modulus")
  as.modular(a$num*b$num, a$mod)
}

`^.modular` <- function(a, b){
  if(!is.integer(b)) stop("exponent must be an integer")
  if(b<=0) stop("exponent must be positive")
  Reduce(`*`, rep(list(a), b))
}

#Need a print method to actually display modular integers
print.modular <- function(n) cat(n$num, " (modulo ", n$mod, ")", sep="")

f <- function(x) x^100L+x+1L
f(as.modular(10L, 13L))
