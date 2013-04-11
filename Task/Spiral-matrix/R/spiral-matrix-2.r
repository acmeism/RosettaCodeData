#more general function, v is assumed to be a vector
spiralv<-function(v){
  n<-sqrt(length(v))
  if(n!=floor(n)) stop(simpleError("length of v should be a square of an integer"))
  if(n==0) stop(simpleError("v should be of positive length"))
  if(n==1) M<-matrix(v,1,1)
  else M<-rbind(v[1:n],cbind(spiralv(v[(2*n):(n^2)])[(n-1):1,(n-1):1],v[(n+1):(2*n-1)]))
  M
}
#wrapper
spiral<-function(n){spiralv(0:(n^2-1))}
#check:
spiral(5)
