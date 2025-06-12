disarium_sum <- function(n, i=ceiling(log10(n))){
  if(n>9){
    return((n%%10)^i+disarium_sum(n%/%10, i-1))
  }
  else return(n)
}

count=0
num=0
while(count<19){
  if(num==disarium_sum(num)){
    print(num)
    count=count+1
  }
  num=num+1
}
