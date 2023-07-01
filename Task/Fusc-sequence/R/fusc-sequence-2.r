index <- which.max(nchar(first61) == 2)
number <- first61[index]
cat("The first fusc number that is longer than all previous fusc numbers is", number,
    "and it occurs at index", index, "\n")
