comb.sort<-function(a){
  gap<-length(a)
  swaps<-1
  while(gap>1 & swaps==1){
    gap=floor(gap/1.3)
    if(gap<1){
      gap=1
      }
    swaps=0
    i=1
    while(i+gap<=length(a)){
        if(a[i]>a[i+gap]){
        a[c(i,i+gap)] <- a[c(i+gap,i)]
        swaps=1
        }
        i<-i+1
      }
  }
  return(a)
}
