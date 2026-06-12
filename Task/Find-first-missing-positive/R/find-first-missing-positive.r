first_missing <- function(v){
  n <- 1
  repeat{
    if(!(n %in% v)){
      return(paste("The first missing positive integer is", n))
    }
    n <- n+1
  }
}

sapply(list(c(1,2,0), c(3,4,-1,1), c(7,8,9,11,12)), first_missing) |> writeLines()
