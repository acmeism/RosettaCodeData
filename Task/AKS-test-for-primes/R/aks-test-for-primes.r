AKS<-function(p){
  i<-2:p-1
  l<-unique(factorial(p) / (factorial(p-i) * factorial(i)))
  if(all(l%%p==0)){
    print(noquote("It is prime."))
  }else{
   print(noquote("It isn't prime."))
  }
}
