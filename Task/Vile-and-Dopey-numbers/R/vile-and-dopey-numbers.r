isvile <- function(n){
  last_one <- bitwAnd(n, -n)
  log2(last_one)%%2==0
}

isdopey <- Negate(isvile)

firstn <- function(lim, pred, name){
  cat("First", lim, name, "numbers:", "\n")
  count <- 0
  n <- 1
  while(count<lim){
    if(pred(n)){
      cat(n, "")
      count <- count+1
    }
    n <- n+1
  }
}

firstn(25, isvile, "vile")
firstn(25, isdopey, "dopey")

vilecount <- function(lim) sum(isvile(1:lim))
dopeycount <- function(lim) lim-vilecount(lim)

counts <- sapply(c(`+`, vilecount, dopeycount),
                 function(f) sapply(2^(1:10), f))

`colnames<-`(counts, c("upto", "viles", "dopeys"))
