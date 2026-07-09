library(gmp)

pp_bigv <- function(title, bigv) {
  cat(title, sapply(bigv, as.character), sep = "\n")
}

wols <- sapply(1:20, function(n) Reduce(`+`, 1/as.bigz(1:n)^2) |> numerator())

pp_bigv("First 20 Wolstenholme numbers:", wols)
pp_bigv("\nFirst 4 prime Wolstenholme numbers:", Filter(isprime, wols))
