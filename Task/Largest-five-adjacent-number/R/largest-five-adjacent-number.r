bignum <- sample(0:9, 1000, replace=TRUE)

nmax <- 0
nmin <- 99999
for(i in 1:995) {
  n <- bignum[i+(0:4)] |> paste0(collapse="") |> as.numeric()
  if(n > nmax) nmax <- n
  if(n < nmin) nmin <- n
}

cat("Random 1000 digits: ", bignum, "\n", sep="")
cat("Max:", nmax, "| Min:", nmin)
