Dragon<-function(Iters){
  Rotation<-matrix(c(0,-1,1,0),ncol=2,byrow=T) ########Rotation multiplication matrix
  Iteration<-list() ###################################Set up list for segment matrices for 1st
  Iteration[[1]] <- matrix(rep(0,16), ncol = 4)
  Iteration[[1]][1,]<-c(0,0,1,0)
  Iteration[[1]][2,]<-c(1,0,1,-1)
  Moveposition<-rep(0,Iters) ##########################Which point should be shifted to origin
  Moveposition[1]<-4
  if(Iters > 1){#########################################where to move to get to origin
    for(l in 2:Iters){#####################################only if >1, because 1 set before for loop
      Moveposition[l]<-(Moveposition[l-1]*2)-2#############sets vector of all positions in matrix where last point is
    }}
  Move<-list() ########################################vector to add to all points to shift start at origin
for (i in 1:Iters){
half<-dim(Iteration[[i]])[1]/2
half<-1:half
for(j in half){########################################Rotate all points 90 degrees clockwise
  Iteration[[i]][j+length(half),]<-c(Iteration[[i]][j,1:2]%*%Rotation,Iteration[[i]][j,3:4]%*%Rotation)
}
Move[[i]]<-matrix(rep(0,4),ncol=4)
Move[[i]][1,1:2]<-Move[[i]][1,3:4]<-(Iteration[[i]][Moveposition[i],c(3,4)]*-1)
Iteration[[i+1]]<-matrix(rep(0,2*dim(Iteration[[i]])[1]*4),ncol=4)##########move the dragon, set next Iteration's matrix
for(k in 1:dim(Iteration[[i]])[1]){#########################################move dragon by shifting all previous iterations point
  Iteration[[i+1]][k,]<-Iteration[[i]][k,]+Move[[i]]###so the start is at the origin
}
xlimits<-c(min(Iteration[[i]][,3])-2,max(Iteration[[i]][,3]+2))#Plot
ylimits<-c(min(Iteration[[i]][,4])-2,max(Iteration[[i]][,4]+2))
plot(0,0,type='n',axes=FALSE,xlab="",ylab="",xlim=xlimits,ylim=ylimits)
s<-dim(Iteration[[i]])[1]
s<-1:s
segments(Iteration[[i]][s,1], Iteration[[i]][s,2], Iteration[[i]][s,3], Iteration[[i]][s,4], col= 'red')
}}#########################################################################
