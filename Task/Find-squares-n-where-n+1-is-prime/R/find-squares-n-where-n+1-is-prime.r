library(gmp)

nums <- 1+(1:floor(sqrt(1000)))^2
nums[isprime(nums)!=0]-1
