pig_game <- function(){
  scores <- tmpscores <- c(0, 0)
  tplayer <- 1
  repeat{
    cat("Player ", tplayer, "'s turn.\n", sep="")
    repeat{
      input <- readline("Hold (H) or roll (R): ") |> tolower()
      if(input %in% c("h", "r")) break
      else cat("That's not a valid input. Try again!\n")
    }
    if(input=="h"){
      scores[tplayer] <- tmpscores[tplayer]
      cat("Player", tplayer, "has", scores[tplayer], "points.\n")
      tplayer <- 3-tplayer
      next
    }
    else if(input=="r"){
      dieroll <- sample(6, 1)
      cat("Player ", tplayer, " rolled a ", dieroll, "!\n", sep="")
      if(dieroll==1){
        cat("Player", tplayer, "is bust!\n")
        cat("Player", tplayer, "has", scores[tplayer], "points.\n")
        tplayer <- 3-tplayer
        next
      }
      else{
        tmpscores[tplayer] <- tmpscores[tplayer]+dieroll
        cat("Player", tplayer, "has", tmpscores[tplayer], "points.\n")
      }
    }
    if(any(tmpscores>=100)) break
  }
  cat("Player", tplayer, "wins!\n")
}

pig_game()
