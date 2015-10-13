halve <- function(a) floor(a/2)
double <- function(a) a*2
iseven <- function(a) (a%%2)==0

ethiopicmult<-function(x,y){
	res<-ifelse(iseven(y),0,x)
	while(!y==1){
		x<-double(x)
		y<-halve(y)
		if(!iseven(y)) res<-res+x
	}
	return(res)
}

print(ethiopicmult(17,34))
