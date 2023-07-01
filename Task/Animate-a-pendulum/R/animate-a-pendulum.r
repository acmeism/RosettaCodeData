library(DescTools)

pendulum<-function(length=5,radius=1,circle.color="white",bg.color="white"){
  tseq = c(seq(0,pi,by=.1),seq(pi,0,by=-.1))
  slow=.27;fast=.07
  sseq = c(seq(slow,fast,length.out = length(tseq)/4),seq(fast,slow,length.out = length(tseq)/4),seq(slow,fast,length.out = length(tseq)/4),seq(fast,slow,length.out = length(tseq)/4))
  plot(0,0,xlim=c((-length-radius)*1.2,(length+radius)*1.2),ylim=c((-length-radius)*1.2,0),xaxt="n",yaxt="n",xlab="",ylab="")
  cat("Press Esc to end animation")

  while(T){
    for(i in 1:length(tseq)){
      rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4],col = bg.color)
      abline(h=0,col="grey")
      points(0,0)
      DrawCircle((radius+length)*cos(tseq[i]),(radius+length)*-sin(tseq[i]),r.out=radius,col=circle.color)
      lines(c(0,length*cos(tseq[i])),c(0,length*-sin(tseq[i])))
      Sys.sleep(sseq[i])
    }
  }

}

pendulum(5,1,"gold","lightblue")
