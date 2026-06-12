library(stringi)
library(dplyr)

check_abc <- function(w) {
  char_list <- stri_split_boundaries(w, type='character')[[1]]
  fpos   <- lapply(c("a","b","c"),\(x) grep(x,char_list)) %>% sapply(\(x) x[1])
  if (any(is.na(fpos)==T)) return(F)
  ifelse(all(sort(fpos) == fpos),T,F)
}

rep <- sapply(readLines("unixdict.txt"), \(x) check_abc(x))
print(names(rep[rep == T]))
