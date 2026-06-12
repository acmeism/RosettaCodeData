library(gmp)

nums <- 2+(1:199)^3
inds <- isprime(nums)!=0
results <- data.frame("n"=(1:199)[inds], "prime"=nums[inds])
print(results, row.names=FALSE)
