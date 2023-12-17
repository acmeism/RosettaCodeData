library(stringi)

abbrev <- function(w) {
  w1 <- stri_split_fixed(w," ") %>% unlist()
  if (length(w1) != 7) stop("Error: not enough days in the week.")
  maxv <- max(sapply(w1,\(x) nchar(x)))
  for (i in 1:maxv) {
    tl <- stri_sub(w1,1,i) %>% unique() %>% length()
    if (tl == 7) return(i)
  }
}

# Main
lines <- readLines("daysOfWeek.txt")
for (l in lines) {
  if (nchar(l) == 0) {
    cat("\n")
  } else {
    cat(paste(abbrev(l),l),"\n")
  }
}
