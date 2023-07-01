library(digest)

input <- "Rosetta code"
cat(digest(input, algo = "sha256", serialize = FALSE), "\n")
