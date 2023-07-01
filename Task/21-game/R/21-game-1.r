game21<-function(first = c("player","ai","random"),sleep=.5){
  state = 0
  finished = F
  turn = 1
  if(length(first)==1 && startsWith(tolower(first),"r")){
    first = rbinom(1,1,.5)
  }else{
    first = (length(first)>1 || startsWith(tolower(first),"p"))
  }
  while(!finished){
    if(turn>1 || first){
      cat("The total is now",state,"\n");Sys.sleep(sleep)
      while(T){
        player.move = readline(prompt = "Enter move: ")
        if((player.move=="1"||player.move=="2"||player.move=="3") && state+as.numeric(player.move)<=21){
          player.move = as.numeric(player.move)
          state = state + player.move
          break
        }else if(tolower(player.move)=="exit"|tolower(player.move)=="quit"|tolower(player.move)=="end"){
          cat("Goodbye.\n")
          finished = T
          break
        }else{
          cat("Error: invaid entry.\n")
        }
      }
    }
    if(state == 21){
      cat("You win!\n")
      finished = T
    }
    if(!finished){
      cat("The total is now",state,"\n");Sys.sleep(sleep)
      while(T){
        ai.move = sample(1:3,1)
        if(state+ai.move<=21){
          break
        }
      }
      state = state + ai.move
      cat("The AI chooses",ai.move,"\n");Sys.sleep(sleep)
      if(state == 21){
        cat("The AI wins!\n")
        finished = T
      }
    }
    turn = turn + 1
  }
}
