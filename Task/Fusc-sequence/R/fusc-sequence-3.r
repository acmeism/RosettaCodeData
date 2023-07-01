twentyMillion <- firstNFuscNumbers(2 * 10^7)
twentyMillionCountable <- format(twentyMillion, scientific = FALSE, trim = TRUE)
indices <- sapply(2:6, function(x) which.max(nchar(twentyMillionCountable) == x))
numbers <- twentyMillion[indices]
cat("Some fusc numbers that are longer than all previous fusc numbers are:\n",
    paste0(format(twentyMillion[indices], scientific = FALSE, trim = TRUE, big.mark = ","),
          " (at index ", format(indices, trim = TRUE, big.mark = ","), ")\n"))
