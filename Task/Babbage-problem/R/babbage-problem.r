babbage_function=function(){
  n=0
  while (n**2%%1000000!=269696) {
    n=n+1
  }
  return(n)
}
babbage_function()[length(babbage_function())]
