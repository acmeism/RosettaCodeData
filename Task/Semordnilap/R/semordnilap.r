library(stringi)

unixdict <- read.table("unixdict.txt", col.names = "forwards")
unixdict$backwards <- stri_reverse(unixdict$forwards)

#Remove all actual palindromes, as we do not want those
unixdict <- subset(unixdict, forwards != backwards)

unixdict$semordnilap <- with(unixdict, sapply(forwards, function(x) x %in% backwards))

semordnilaps <- subset(unixdict,
                       semordnilap & forwards > backwards,
                       select = -semordnilap)

nsemordnilaps <- nrow(semordnilaps)
cat("There are", nsemordnilaps, "semordnilaps in unixdict.txt.\n")
randrows <- sample(nsemordnilaps, 5, replace = FALSE)
print(semordnilaps[randrows, ], row.names = FALSE)
