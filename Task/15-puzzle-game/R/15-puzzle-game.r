puz15<-function(scramble.length=100){
  m=matrix(c(1:15,0),byrow=T,ncol=4)
  scramble=sample(c("w","a","s","d"),scramble.length,replace=T)
  for(i in 1:scramble.length){
    m=move(m,scramble[i])
  }
  win=F
  turn=0
  while(!win){
    print.puz(m)
    newmove=getmove()
    if(newmove=="w"|newmove=="a"|newmove=="s"|newmove=="d"){
      m=move(m,newmove)
      turn=turn+1
    }
    else{
      cat("Input not recognized","\n")
    }
    if(!(F %in% m==matrix(c(1:15,0),byrow=T,ncol=4))){
      win=T
    }
  }
  print.puz(m)
  cat("\n")
  print("You win!")
  cat("\n","It took you",turn,"moves.","\n")
}

getmove<-function(){
  direction<-readline(prompt="Move:")
  return(direction)
}
move<-function(m,direction){
  if(direction=="w"){
    m=move.u(m)
  }
  else if(direction=="s"){
    m=move.d(m)
  }
  else if(direction=="a"){
    m=move.l(m)
  }
  else if(direction=="d"){
    m=move.r(m)
  }
  return(m)
}
move.u<-function(m){
  if(0 %in% m[4,]){}
  else{
    pos=which(m==0)
    m[pos]=m[pos+1]
    m[pos+1]=0
  }
  return(m)
}
move.d<-function(m){
  if(0 %in% m[1,]){}
  else{
    pos=which(m==0)
    m[pos]=m[pos-1]
    m[pos-1]=0
  }
  return(m)
}
move.l<-function(m){
  if(0 %in% m[,4]){return(m)}
  else{return(t(move.u(t(m))))}
}
move.r<-function(m){
  if(0 %in% m[,1]){return(m)}
  else{return(t(move.d(t(m))))}
}
print.puz<-function(m){
  cat("+----+----+----+----+","\n")
  for(r in 1:4){
    string="|"
    for(c in 1:4){
      if(m[r,c]==0)
        string=paste(string,"    |",sep="")
      else if(m[r,c]<10)
        string=paste(string,"  ",m[r,c]," |",sep="")
      else
        string=paste(string," ",m[r,c]," |",sep="")
    }
    cat(string,"\n","+----+----+----+----+","\n",sep="")
  }
}
