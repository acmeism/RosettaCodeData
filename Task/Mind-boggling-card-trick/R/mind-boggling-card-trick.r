magictrick<-function(){
  deck=c(rep("B",26),rep("R",26))
  deck=sample(deck,52)
  blackpile=character(0)
  redpile=character(0)
  discardpile=character(0)
  while(length(deck)>0){
    if(deck[1]=="B"){
      blackpile=c(blackpile,deck[2])
      deck=deck[-2]
    }else{
      redpile=c(redpile,deck[2])
      deck=deck[-2]
    }
    discardpile=c(discardpile,deck[1])
    deck=deck[-1]
  }
  cat("After the deal the state of the piles is:","\n",
      "Black pile:",blackpile,"\n","Red pile:",redpile,"\n",
      "Discard pile:",discardpile,"\n","\n")
  X=sample(1:min(length(redpile),length(blackpile)),1)
  if(X==1){s=" is"}else{s="s are"}
  cat(X," card",s," being swapped.","\n","\n",sep="")
  redindex=sample(1:length(redpile),X)
  blackindex=sample(1:length(blackpile),X)
  redbunch=redpile[redindex]
  redpile=redpile[-redindex]
  blackbunch=blackpile[blackindex]
  blackpile=blackpile[-blackindex]
  redpile=c(redpile,blackbunch)
  blackpile=c(blackpile,redbunch)
  cat("After the swap the state of the piles is:","\n",
      "Black pile:",blackpile,"\n","Red pile:",redpile,"\n","\n")
  cat("There are ", length(which(blackpile=="B")), " black cards in the black pile.","\n",
      "There are ", length(which(redpile=="R")), " red cards in the red pile.","\n",sep="")
  if(length(which(blackpile=="B"))==length(which(redpile=="R"))){
    cat("The assertion is true!")
  }
}
