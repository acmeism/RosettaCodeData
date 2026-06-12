phi=1/2+sqrt(5)/2
r=seq(0,1,length.out=2000)
theta=numeric(length(r))
theta[1]=0
for(i in 2:length(r)){
  theta[i]=theta[i-1]+phi*2*pi
}
x=r*cos(theta)
y=r*sin(theta)
par(bg="black")
plot(x,y)
size=seq(.5,2,length.out = length(x))
thick=seq(.1,2,length.out = length(x))
for(i in 1:length(x)){
  points(x[i],y[i],cex=size[i],lwd=thick[i],col="goldenrod1")
}
