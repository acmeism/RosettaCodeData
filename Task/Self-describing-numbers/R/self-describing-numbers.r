library(stringr)
options(scipen=99)

is_selfdescribing <- function(n){
  if(n%%10 != 0) return(FALSE)
  digits <- str_split_1(as.character(n), "")
  k <- length(digits)
  for(i in k:1){
    d <- as.character(i-1)
    if(sum(str_count(digits, d)) != digits[i]) return(FALSE)
  }
  return(TRUE)
}

Filter(is_selfdescribing, 1:4000000)
