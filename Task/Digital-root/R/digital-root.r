y=1
digital_root=function(n){
  x=sum(as.numeric(unlist(strsplit(as.character(n),""))))
  if(x<10){
    k=x
  }else{
    y=y+1
    assign("y",y,envir = globalenv())
    k=digital_root(x)
  }
  return(k)
}
print("Given number has additive persistence",y)
