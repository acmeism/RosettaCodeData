canMakeNoRecursion <- function(x) {
  x <- toupper(x)
  charList <- strsplit(x, character(0))
  getCombos <- function(chars) {
    charBlocks <-  data.matrix(expand.grid(lapply(chars, function(char) which(blocks == char, arr.ind=TRUE)[, 1L])))
    charBlocks <- charBlocks[!apply(charBlocks, 1, function(row) any(duplicated(row))), , drop=FALSE]
    if (dim(charBlocks)[1L] > 0L) {
      t(apply(charBlocks, 1, function(row) apply(blocks[row, , drop=FALSE], 1, paste, collapse="")))
    } else {
      character(0)
    }
  }
  setNames(lapply(charList, getCombos), x)
}
canMakeNoRecursion(c("A",
           "BARK",
           "BOOK",
           "TREAT",
           "COMMON",
           "SQUAD",
           "CONFUSE"))
