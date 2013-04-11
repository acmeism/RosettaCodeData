cube <- function(x) x^3
croot <- function(x) x^(1/3)
compose <- function(f, g) function(x){f(g(x))}

f1 <- c(sin, cos, cube)
f2 <- c(asin, acos, croot)

for(i in 1:3) {
  print(compose(f1[[i]], f2[[i]])(.5))
}
