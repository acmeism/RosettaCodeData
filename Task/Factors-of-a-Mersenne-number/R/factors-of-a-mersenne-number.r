num_bits <- function(n) ifelse(log2(n)%%1==0,
                               1+log2(n),
                               ceiling(log2(n)))

mod_pow <- function(base, expo, mod){
  exp_bin <- rev(intToBits(expo)[1:num_bits(expo)])
  square <- 1
  while(length(exp_bin)>0){
    square <- square^2
    if(as.logical(exp_bin[1])) square <- square*base
    exp_bin <- exp_bin[-1]
    square <- square%%mod
  }
  return(square)
}

k <- 1
repeat{
  q <- 2*929*k+1
  if(!(q%%8 %in% c(1, 7))){
    k <- k+1
    next
  }
  if(mod_pow(2, 929, q)==1){
    cat("Found factor of M929:", q)
    break
  }
  k <- k+1
}
