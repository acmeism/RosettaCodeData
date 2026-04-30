num_bits <- function(n) ifelse(log2(n)%%1==0,
                               1+log2(n),
                               ceiling(log2(n)))

vdc <- function(n){
  if(n==0) return(0)
  inds <- 1:num_bits(n)
  vdc_raw <- intToBits(n)[inds]
  sum(as.numeric(vdc_raw)*(2^-inds))
}

sapply(0:9, vdc)
