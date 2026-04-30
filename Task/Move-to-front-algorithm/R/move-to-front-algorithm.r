encodeMTF <- function(str, symtable = letters) {
  encode <- function(ch) {
    r <- which(symtable == ch)
    symtable <<- c(ch, symtable[-r])
    return(r)
  }
  sapply(strsplit(str, "")[[1]], encode)
}

decodeMTF <- function(arr, symtable = letters) {
  decode <- function(i) {
    r <- symtable[i]
    symtable <<- c(r, symtable[-i])
    return(r)
  }
  paste(sapply(arr, decode), collapse = "")
}

testset <- c("broood", "bananaaa", "hiphophiphop")
encoded <- lapply(testset, encodeMTF)
decoded <- mapply(decodeMTF, encoded)

for (i in seq_along(testset)) {
  cat("Test string:", testset[i], "\n -> Encoded:", paste(encoded[[i]], collapse = ", "), "\n -> Decoded:", decoded[i], "\n\n")
}

# Test if decoded strings equal original
all(sapply(seq_along(testset), function(i) identical(testset[i], decoded[i])))
