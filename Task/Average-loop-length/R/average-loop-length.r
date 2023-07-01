expected <- function(size) {
  result <- 0
  for (i in 1:size) {
    result <- result + factorial(size) / size^i / factorial(size -i)
  }
  result
}

knuth <- function(size) {
  v <- sample(1:size, size, replace = TRUE)

  visit <- vector('logical',size)
  place <- 1
  visit[[1]] <- TRUE
  steps <- 0

  repeat {
    place <- v[[place]]
    steps <- steps + 1
    if (visit[[place]]) break
    visit[[place]] <- TRUE
  }
  steps
}

cat(" N    average    analytical     (error)\n")
cat("===  =========  ============  ==========\n")
for (num in 1:20) {
  average <- mean(replicate(1e6, knuth(num)))
  analytical <- expected(num)
  error <- abs(average/analytical-1)*100

  cat(sprintf("%3d%11.4f%14.4f  ( %4.4f%%)\n", num, round(average,4), round(analytical,4), round(error,2)))
}
