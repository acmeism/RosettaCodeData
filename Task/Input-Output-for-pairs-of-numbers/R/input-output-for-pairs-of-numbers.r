sum_io <- function(){
  nlines <- readline("Input number of pairs: ") |> as.numeric()
  nums <- readLines(n=nlines) |> strsplit(" ") |> lapply(as.numeric)
  sums <- sapply(nums, sum)
  cat("", sums, sep="\n")
}

sum_io()
