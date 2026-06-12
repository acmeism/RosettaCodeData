regexp_twice <- function(s) paste0("^[^",s,"]*",s,"[^",s,"]*",s,"[^",s,"]*$")
appears_twice <- function(s, char) grepl(regexp_twice(char), s)

is_specific <- function(v, char){
  bools <- logical(0)
  for(i in seq_along(v)){
    bools <- c(bools, appears_twice(v[i], char)&all(!grepl(char, v[-i])))
  }
  return(bools)
}

num_specifics <- function(v, negate=FALSE){
  list_chars <- lapply(strsplit(v, ""), unique)
  nums <- numeric(0)
  for(i in seq_along(v)){
    flags <- sapply(list_chars[[i]], function(char) is_specific(v, char)[i])
    nums <- c(nums, ifelse(negate, sum(!flags), sum(flags)))
  }
  return(nums)
}

test_strings <- c("ahwiueshaiu","ajxxfioaaf","ajrdsfroiwr")
num_specifics(test_strings)
num_specifics(test_strings, negate=TRUE)
