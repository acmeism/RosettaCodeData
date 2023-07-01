blocks <- rbind(c("B","O"),
 c("X","K"),
 c("D","Q"),
 c("C","P"),
 c("N","A"),
 c("G","T"),
 c("R","E"),
 c("T","G"),
 c("Q","D"),
 c("F","S"),
 c("J","W"),
 c("H","U"),
 c("V","I"),
 c("A","N"),
 c("O","B"),
 c("E","R"),
 c("F","S"),
 c("L","Y"),
 c("P","C"),
 c("Z","M"))

canMake <- function(x) {
  x <- toupper(x)
  used <- rep(FALSE, dim(blocks)[1L])
  charList <- strsplit(x, character(0))
  tryChars <- function(chars, pos, used, inUse=NA) {
    if (pos > length(chars)) {
      TRUE
    } else {
      used[inUse] <- TRUE
      possible <- which(blocks == chars[pos] & !used, arr.ind=TRUE)[, 1L]
      any(vapply(possible, function(possBlock) tryChars(chars, pos + 1, used, possBlock), logical(1)))
    }
  }
  setNames(vapply(charList, tryChars, logical(1), 1L, used), x)
}
canMake(c("A",
           "BARK",
           "BOOK",
           "TREAT",
           "COMMON",
           "SQUAD",
           "CONFUSE"))
