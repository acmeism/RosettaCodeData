library(combinat)

permute.me <- c("A", "B", "C", "D")
perms  <- permn(permute.me)  # list of all permutations
perms2 <- matrix(unlist(perms), ncol=length(permute.me), byrow=T)  # matrix of all permutations
perms3 <- apply(perms2, 1, paste, collapse="")  # vector of all permutations

incomplete <- c("ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD", "ADCB", "CDAB",
                "DABC", "BCAD", "CADB", "CDBA", "CBAD", "ABDC", "ADBC", "BDCA",
                "DCBA", "BACD", "BADC", "BDAC", "CBDA", "DBCA", "DCAB")

setdiff(perms3, incomplete)
