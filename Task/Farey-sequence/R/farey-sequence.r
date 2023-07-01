farey <- function(n, length_only = FALSE) {
  a <- 0
  b <- 1
  c <- 1
  d <- n
  if (!length_only)
    cat(a, "/", b, sep = "")
  count <- 1
  while (c <= n) {
    count <- count + 1
    k <- ((n + b) %/% d)
    next_c <- k * c - a
    next_d <- k * d - b
    a <- c
    b <- d
    c <- next_c
    d <- next_d
    if (!length_only)
      cat(" ", a, "/", b, sep = "")
  }
  if (length_only)
    cat(count, "items")
  cat("\n")
}


for (i in 1:11) {
  cat(i, ": ", sep = "")
  farey(i)
}

for (i in 100 * 1:10) {
  cat(i, ": ", sep = "")
  farey(i, length_only = TRUE)
}
