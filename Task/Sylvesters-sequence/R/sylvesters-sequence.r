library(gmp)

sylvester <- function(n){
  if(n==1) as.bigz(2)
  else 1+Reduce(`*`, lapply(seq_len(n-1), sylvester))
}

vals <- print(lapply(1:10, sylvester), initLine=FALSE)
recips <- lapply(vals, function(x) 1/x)
print(Reduce(`+`, recips), initLine=FALSE)
