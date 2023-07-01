Identity_matrix=function(size){
  x=matrix(0,size,size)
  for (i in 1:size) {
    x[i,i]=1
  }
  return(x)
}
