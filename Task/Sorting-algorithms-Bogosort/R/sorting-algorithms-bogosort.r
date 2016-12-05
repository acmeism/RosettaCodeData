bogosort <- function(x) {
   while(is.unsorted(x)) x <- sample(x)
   x
}

n <- c(1, 10, 9, 7, 3, 0)
bogosort(n)
