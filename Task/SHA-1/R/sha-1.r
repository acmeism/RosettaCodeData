library(digest)

input <- "Rosetta Code"
cat(digest(input, algo = "sha1", serialize = FALSE), "\n")
