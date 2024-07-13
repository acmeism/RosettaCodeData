library(gmp) #for big number factorization

arithmetic_derivative<-function(x){
  if (x==0|x==1|x==-1){
    D=0
  }
  else{
    n=ifelse(x<0,-x,x)
    prime_decomposition <-as.numeric(factorize(n))
    if (length(prime_decomposition)==1){
      D<- 1
    }
    else{
      D<-sum(prime_decomposition[c(1,2)])
      if (length(prime_decomposition)>2){
        cumulative_prod <-cumprod(prime_decomposition)
        for (i in 3:length(prime_decomposition)){
          D<- D * prime_decomposition[i]  + cumulative_prod[i-1]
        }
      }
    }

  }
  sign(x)*D
}

print(t(matrix(sapply(-99:100,arithmetic_derivative),nrow=10)))

for (k in 1:20){
  x <- 10**k
  cat(paste0("D(",x,")/7 = ",arithmetic_derivative(x)/7,"\n"),sep = "")}
