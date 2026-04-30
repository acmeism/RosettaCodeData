#Express the 12 statements programmatically
test_12 <- function(v){
  c(length(v)==12,
    sum(v[7:12])==3,
    sum(v[2*(1:6)])==2,
    ifelse(v[5], v[6]&v[7], TRUE),
    !any(v[2:4]),
    sum(v[2*(1:6)-1])==4,
    xor(v[2], v[3]),
    ifelse(v[7], v[5]&v[6], TRUE),
    sum(v[1:6])==3,
    all(v[11:12]),
    sum(v[7:9])==1,
    sum(v)==4)
}

#Find solution and near misses
for(i in 0:4095){
  v <- as.logical(intToBits(i))[1:12]
  if(all(v==test_12(v))){
    cat(which(v), "(all correct)\n")
  }
  if(sum(v!=test_12(v))==1){
    cat(which(v), "(statement", which(v!=test_12(v)), "wrong)\n")
  }
}
