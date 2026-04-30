options(scipen=13)
seed <- 675248

middlesquare <- function(){
  s <- as.character(seed^2)
  k <- nchar(s)
  if(k<12) s <- paste0(strrep("0", 12-k), s)
  seed <<- substr(s, 4, 9) |> as.numeric()
  return(seed)
}

replicate(5, middlesquare())
