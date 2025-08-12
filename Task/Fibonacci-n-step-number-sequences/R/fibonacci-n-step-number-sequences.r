#First define matrix exponentiation (R doesn't natively have this)
`%^%` <- function(mat,n) Reduce(`%*%`, rep(list(mat), n))

#For the nth Fibonacci-like sequence Fn, this function generates the matrix
#that will transform the vector (Fn_k, Fn_k-1, ..., Fn_k-n) to the vector
#(Fn_k+1, Fn_k, ..., Fn_k-n+1) i.e. determine the next member of the sequence
gen_nfibmat <- function(n){
  id <- diag(1, n-1, n-1)
  nfibmat <- rbind(rep(1,n-1),id)
  nfibmat <- cbind(nfibmat, c(1, rep(0,n-1)))
  return(nfibmat)
}

#This function generates a vector of initial values (which, you will notice from
#looking at the sequences, are always 1 followed by the first n-1 powers of 2)
gen_init <- function(n) rev(c(1, 2^(0:(n-2))))

#Now it's easy to define any Fibonacci-like n-step sequence
fiblike <- function(n,k){
  if(k<=n) rev(gen_init(n))[k]
  else ((gen_nfibmat(n)%^%(k-n))%*%gen_init(n))[1]
}

fibonacci <- function(k) fiblike(2,k)
tribonacci <- function(k) fiblike(3,k)
tetrabonacci <- function(k) fiblike(4,k)

lucas <- function(k){
  if(k<=2) c(2,1)[k]
  else ((gen_nfibmat(2)%^%(k-2))%*%c(1,2))[1]
}

seqnames <- c("fibonacci","tribonacci","tetrabonacci","lucas")
setNames(lapply(str2expression(seqnames), function(f) sapply(1:15, f)), seqnames)
