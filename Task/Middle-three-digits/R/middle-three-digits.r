#Simple method
options(scipen=99)

middle3digits <- function(n){
  s <- abs(n) |> as.character()
  k <- nchar(s)
  if(k<3) stop("not enough digits")
  if(k%%2==0) stop("even number of digits")
  substr(s, (k-1)/2, (k+3)/2)
}

#Alternate method without disabling scientific notation
numdigits <- function(n) ifelse(log10(n)%%1==0,
                                1+log10(n),
                                ceiling(log10(n)))

middle3digits <- function(n){
  n <- abs(n)
  k <- numdigits(n)
  if(k<3|is.na(k)) stop("not enough digits")
  if(k%%2==0) stop("even number of digits")
  pow10 <- 10^((k-3)/2)
  mid <- (n%/%pow10)%%1000
  if(mid<100){
    mid <- as.character(mid)
    mid_pad <- paste0(c(rep(0, 3-nchar(mid)), mid), collapse="")
    return(mid_pad)
  }
  return(as.character(mid))
}

#Testing examples
test_nums <- c(123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345)
test_errors <- c(1, 2, -1, -10, 2002, -2002, 0)
cat(sapply(test_nums, middle3digits))
for(n in test_errors) try(middle3digits(n))
