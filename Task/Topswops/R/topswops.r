topswops <- function(x){
  i <- 0
  while(x[1] != 1){
    first <- x[1]
    if(first == length(x)){
      x <- rev(x)
    } else{
      x <- c(x[first:1], x[(first+1):length(x)])
    }
    i <- i + 1
  }
  return(i)
}

library(iterpc)

result <- NULL

for(i in 1:10){
  I <- iterpc(i, labels = 1:i, ordered = T)
  A <- getall(I)
  A <- data.frame(A)
  A$flips <- apply(A, 1, topswops)
  result <- rbind(result, c(i, max(A$flips)))
}
