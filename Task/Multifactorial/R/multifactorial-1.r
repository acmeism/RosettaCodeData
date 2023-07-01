#x is Input
#n is Factorial Number
multifactorial=function(x,n){
  if(x<=n+1){
    return(x)
  }else{
    return(x*multifactorial(x-n,n))
  }
}
