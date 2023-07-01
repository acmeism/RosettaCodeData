pieces <- c("R","B","N","Q","K","N","B","R")

generateFirstRank <- function() {
  attempt <- paste0(sample(pieces), collapse = "")
  while (!check_position(attempt)) {
    attempt <- paste0(sample(pieces), collapse = "")
  }
  return(attempt)
}

check_position <- function(position) {
  if (regexpr('.*R.*K.*R.*', position) == -1) return(FALSE)
  if (regexpr('.*B(..|....|......|)B.*', position) == -1) return(FALSE)
  TRUE
}

convert_to_unicode <- function(s) {
  s <- sub("K","\u2654", s)
  s <- sub("Q","\u2655", s)
  s <- gsub("R","\u2656", s)
  s <- gsub("B","\u2657", s)
  s <- gsub("N","\u2658", s)
}

cat(convert_to_unicode(generateFirstRank()), "\n")
