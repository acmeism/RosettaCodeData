library(stringr)

cusip_checkdigit <- function(s){
  sum <- 0
  chars <- str_split_1(s,"")
  for(i in 1:8){
    if(str_detect(chars[i],"[0-9]")) v <- as.numeric(chars[i])
    else if(str_detect(chars[i],"[A-Z]")) v <- 9+which(LETTERS==chars[i])
    else v <- switch(chars[i], "*"=36, "@"=37, "#"=38)
    if(i%%2==0) v <- 2*v
    sum <- sum+v%/%10+v%%10
  }
  return((10-(sum%%10))%%10)
}

cusip_isvalid <- function(s){
  if(str_length(s)!=9){
    stop("CUSIP must have exactly 9 characters")
  }
  checksum <- cusip_checkdigit(s) |> as.character()
  ifelse(endsWith(s, checksum), "Valid CUSIP", "Invalid CUSIP")
}

test_cusips <- c("037833100","17275R102","38259P508","594918104","68389X106","68389X105")
sapply(test_cusips, cusip_isvalid)
