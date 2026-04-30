p <- 1
s <- 0
x <- 5
y <- -5
z <- -2
one <- 1
three <- 3
seven <- 7

process <- function(j) {
  s <<- s + abs(j)
  if(abs(p) < 2^27 && j!=0) p <<- p*j
}

multifor <- function(f, l){
  for(v in l){
    vseq <- do.call(seq, as.list(v))
    for(j in vseq) f(j)
  }
}

test_ranges <- list(c(-three, 3^3, three),
                    c(-seven, seven, x),
                    c(555, 550-y),
                    c(22, -28, -three),
                    c(1927, 1939),
                    c(x, y, z),
                    c(11^x, 11^x + one))

multifor(process, test_ranges)
cat("Sum:", s, "\nProduct:", p)
