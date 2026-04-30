#R only supports 32-bit integers, so pop-count is at most 31
primes <- c(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31)
popcount <- function(n) sum(as.numeric(intToBits(n)))
is_pernicious <- function(n) popcount(n) %in% primes

nums <- numeric(0)
n <- 1
while(length(nums)<25){
  if(is_pernicious(n)) nums <- c(nums, n)
  n <- n+1
}
print(nums)

Filter(is_pernicious, 888888877:888888888)
