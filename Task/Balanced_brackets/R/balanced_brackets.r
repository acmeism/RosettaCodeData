balanced <- function(str){
  str <- strsplit(str, "")[[1]]
  str <- ifelse(str=='[', 1, -1)
  all(cumsum(str) >= 0) && sum(str) == 0
}
