cache <- vector("integer", 0)
cache[1] <- 1
cache[2] <- 1

Q <- function(n) {
  if (is.na(cache[n])) {
    value <- Q(n-Q(n-1)) + Q(n-Q(n-2))
    cache[n] <<- value
  }
  cache[n]
}

for (i in 1:1e5) {
  Q(i)
}

for (i in 1:10) {
  cat(Q(i)," ",sep = "")
}
cat("\n")
cat(Q(1000),"\n")

count <- 0
for (i in 2:1e5) {
  if (Q(i) < Q(i-1)) count <- count + 1
}
cat(count,"terms is less than its preceding term\n")
