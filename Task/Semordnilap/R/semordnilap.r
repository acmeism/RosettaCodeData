library(stringi)

semordnilaps <- read.table("unixdict.txt", col.names = "forwards") |>
  transform(backwards = stri_reverse(forwards)) |>
  subset(forwards != backwards) |> #Remove all palindromes
  transform(semordnilap = sapply(forwards, function(x) x %in% backwards)) |>
  subset(semordnilap & forwards > backwards, select = -semordnilap)

nsemordnilaps <- nrow(semordnilaps)
cat("There are", nsemordnilaps, "semordnilaps in unixdict.txt.\n")
randrows <- sample(nsemordnilaps, 5, replace = FALSE)
print(semordnilaps[randrows, ], row.names = FALSE)
