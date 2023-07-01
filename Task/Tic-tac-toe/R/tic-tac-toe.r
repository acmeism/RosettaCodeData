rm(list=ls())
library(RColorBrewer)


# Create tic.tac.toe function.


tic.tac.toe <- function(name="Name", mode=0, type=0){

  place.na <<- matrix(1:9, 3, 3)
  value <<- matrix(-3, 3, 3)
  k <<- 1 ; r <<- 0


  # Make game board.


  image(1:3, 1:3, matrix(sample(9), 3, 3), asp=c(1, 1),
        xaxt="n", yaxt="n", xlab="", ylab="", frame=F, col=brewer.pal(9, "Set3"))
  segments(c(0.5,0.5,1.5,2.5), c(2.5,1.5,0.5,0.5),
           c(3.5,3.5,1.5,2.5), c(2.5,1.5,3.5,3.5), lwd=8, col=gray(0.3))
  segments(c(0.5,0.5,0.5,3.5), c(0.52,3.47,0.5,0.5),
           c(3.5,3.5,0.5,3.5), c(0.52,3.47,3.5,3.5), lwd=8, col=gray(0.3))


  # Allow player to choose between a human v. human, human v. random AI, or human vs. smart AI.

  if(mode==0) title(list(paste(name, "'s Tic-Tac-Toe !"), cex=2),
                    "2P : Human v.s. Human", font.sub=2, cex.sub=2)
  if(mode==1) title(list(paste(name, "'s Tic-Tac-Toe !"), cex=2),
                    "1P : Human v.s. AI (Easy)", font.sub=2, cex.sub=2)
  if(mode==2) title(list(paste(name, "'s Tic-Tac-Toe !"), cex=2),
                    "1P : Human v.s. AI (Hard)", font.sub=2, cex.sub=2)


  # Dole out symbols.

  if(type==0){symbol <- "O" ; symbol.op <- "X"}
  if(type==1){symbol <- "X" ; symbol.op <- "O"}
  out <- list(name=name, mode=mode, type=type, symbol=symbol, symbol.op=symbol.op)
}

# Checks if the game has ended.

isGameOver <- function(){

  for(i in 1:3){
    total.1 <- 0 ; total.2 <- 0
    for(j in 1:3){
      total.1 <- total.1 + value[i, j]
      total.2 <- total.2 + value[j, i]
    }
    if(total.1==0 | total.2==0 | total.1==3 | total.2==3){
      break
    }
  }
  total.3 <- value[1, 1] + value[2, 2] + value[3, 3]
  total.4 <- value[1, 3] + value[2, 2] + value[3, 1]

  if(total.1==0 | total.2==0 | total.3==0 | total.4==0 | total.1==3 | total.2==3 | total.3==3 | total.4==3){
    place.na[!is.na(place.na)] <<- NA
    if(total.1==0 | total.2==0 | total.3==0 | total.4==0){
      title(sub=list("You Won ?! That's a first!", col="red", font=2, cex=2.5), line=2)
    }else{
      title(sub=list("You Don't Get Tired of Losing ?!", col="darkblue", font=2, cex=2.5), line=2)
    }
  }

  if(all(is.na(place.na))){
    if(total.1==0 | total.2==0 | total.3==0 | total.4==0 | total.1==3 | total.2==3 | total.3==3 | total.4==3){
      if(total.1==0 | total.2==0 | total.3==0 | total.4==0){
        title(sub=list("You Won ! Pigs Must Be Flying!", col="orange", font=2, cex=2.5), line=2)
      }else{
        title(sub=list("You Lost ... Once Again !", col="darkblue", font=2, cex=2.5), line=2)
      }
    }else{
      title(sub=list("A measly tie! Try Again", col="blue", font=2, cex=2.5), line=2)
    }
  }
}


# AI attack function


attack <- function(){
  ### Identify rows and columns
  for(i in 1:3){
    total.1 <- 0 ; total.2 <- 0
    for(j in 1:3){
      total.1 <- total.1 + value[i, j]
      total.2 <- total.2 + value[j, i]
    }
    if(total.1==-1 | total.2==-1){
      break
    }
  }
  total.3 <- value[1, 1] + value[2, 2] + value[3, 3]
  total.4 <- value[1, 3] + value[2, 2] + value[3, 1]

  if(total.1==-1){
    text(i, which(value[i,]!=1), symbol.op, cex=6, font=2)
    place.na[i, which(value[i,]!=1)] <<- NA
    value[i, which(value[i,]!=1)] <<- 1
  }else if(total.2==-1){
    text(which(value[,i]!=1), i, symbol.op, cex=6, font=2)
    place.na[which(value[,i]!=1), i] <<- NA
    value[which(value[,i]!=1), i] <<- 1
  }else if(total.3==-1){
    r.1 <- which(c(value[1, 1], value[2, 2], value[3, 3])!=1)
    text(r.1, r.1, symbol.op, cex=6, font=2)
    place.na[r.1, r.1] <<- NA
    value[r.1, r.1] <<- 1
  }else if(total.4==-1){
    r.2 <- which(c(value[1, 3], value[2, 2], value[3, 1])!=1)
    text(r.2, -r.2+4, symbol.op, cex=6, font=2)
    place.na[r.2, -r.2+4] <<- NA
    value[r.2, -r.2+4] <<- 1
  }
}


# AI defense function


defend <- function(){

  for(i in 1:3){
    total.1 <- 0 ; total.2 <- 0
    for(j in 1:3){
      total.1 <- total.1 + value[i, j]
      total.2 <- total.2 + value[j, i]
    }
    if(total.1==-3 | total.2==-3){
      break
    }
  }
  total.3 <- value[1, 1] + value[2, 2] + value[3, 3]
  total.4 <- value[1, 3] + value[2, 2] + value[3, 1]

  if(total.1==-3){
    text(i, which(value[i,]!=0), symbol.op, cex=6, font=2)
    place.na[i, which(value[i,]!=0)] <<- NA
    value[i, which(value[i,]!=0)] <<- 1
  }else if(total.2==-3){
    text(which(value[,i]!=0), i, symbol.op, cex=6, font=2)
    place.na[which(value[,i]!=0), i] <<- NA
    value[which(value[,i]!=0), i] <<- 1
  }else if(total.3==-3){
    r.1 <- which(c(value[1, 1], value[2, 2], value[3, 3])!=0)
    text(r.1, r.1, symbol.op, cex=6, font=2)
    place.na[r.1, r.1] <<- NA
    value[r.1, r.1] <<- 1
  }else if(total.4==-3){
    r.2 <- which(c(value[1, 3], value[2, 2], value[3, 1])!=0)
    text(r.2, -r.2+4, symbol.op, cex=6, font=2)
    place.na[r.2, -r.2+4] <<- NA
    value[r.2, -r.2+4] <<- 1
  }else{
    rn <- sample(place.na[!is.na(place.na)], 1)
    text(rn-3*rn%/%3.5, rn%/%3.5+1, symbol.op, cex=6, font=2)
    place.na[rn-3*rn%/%3.5, rn%/%3.5+1] <<- NA
    value[rn-3*rn%/%3.5, rn%/%3.5+1] <<- 1
  }
}


# Allow aim in program.


aim <- function(x, y, tic.tac.toe=ttt){

  mode <- tic.tac.toe$mode
  symbol <<- tic.tac.toe$symbol
  symbol.op <<- tic.tac.toe$symbol.op
  x <<- x ; y <<- y


  # Mode 0, Two Players


  if(mode==0){
    turn <- rep(c(0, 1), length.out=9)
    if(is.na(place.na[x, y])){
      cat("This square is taken !")
    }else{

      if(turn[k]==0){
        text(x, y, symbol, cex=6, font=2)
        place.na[x, y] <<- NA
        value[x, y] <<- 0
      }
      if(turn[k]==1){
        text(x, y, symbol.op, cex=6, font=2)
        place.na[x, y] <<- NA
        value[x, y] <<- 1
      }
      k <<- k + 1
    }
  }


  # Mode 1, Random AI


  if(mode==1){
    if(is.na(place.na[x, y])){
      cat("This square had been chosen !")
    }else{
      text(x, y, symbol, cex=6, font=2)
      place.na[x, y] <<- NA
      value[x, y] <<- 0
      isGameOver()

      for(i in 1:3){
        total.1 <- 0 ; total.2 <- 0
        for(j in 1:3){
          total.1 <- total.1 + value[i, j]
          total.2 <- total.2 + value[j, i]
        }
        if(total.1==-1 | total.2==-1){
          break
        }
      }
      total.3 <- value[1, 1] + value[2, 2] + value[3, 3]
      total.4 <- value[1, 3] + value[2, 2] + value[3, 1]

      if(all(is.na(place.na))){
        isGameOver()
      }else if(total.1==-1 | total.2==-1 | total.3==-1 | total.4==-1){
        attack()
      }else{
        defend()
      }
    }
  }



  # Mode 2, Hard AI


  if(mode==2){

    if(is.na(place.na[x, y])){
      cat("This square is taken!")
    }else{


      # AI First Turn


      if(sum(is.na(place.na))==0){

        text(x, y, symbol, cex=6, font=2)
        place.na[x, y] <<- NA
        value[x, y] <<- 0

        if(is.na(place.na[2, 2])==F){
          text(2, 2, symbol.op, cex=6, font=2)
          place.na[2, 2] <<- NA
          value[2, 2] <<- 1
        }else{
          corner.1 <- sample(c(1, 3), 1) ; corner.2 <- sample(c(1, 3), 1)
          text(corner.1, corner.2, symbol.op, cex=6, font=2)
          place.na[corner.1, corner.2] <<- NA
          value[corner.1, corner.2] <<- 1
        }


        # AI Second Turn


      }else if(sum(is.na(place.na))==2){
        text(x, y, symbol, cex=6, font=2)
        place.na[x, y] <<- NA
        value[x, y] <<- 0

        for(i in 1:3){
          total.1 <- 0 ; total.2 <- 0
          for(j in 1:3){
            total.1 <- total.1 + value[i, j]
            total.2 <- total.2 + value[j, i]
          }
          if(total.1==-3 | total.2==-3){
            break
          }
        }
        total.3 <- value[1, 1] + value[2, 2] + value[3, 3]
        total.4 <- value[1, 3] + value[2, 2] + value[3, 1]

        if(total.1==-3 | total.2==-3 | total.3==-3 | total.4==-3){
          defend()
        }else{
          total.1 <- value[2, 1] + value[2, 2] + value[2, 3]
          total.2 <- value[1, 2] + value[2, 2] + value[3, 2]
          total.3 <- value[1, 1] + value[2, 2] + value[3, 3]
          total.4 <- value[1, 3] + value[2, 2] + value[3, 1]
          if(total.1==1 | total.2==1 | total.3==1 | total.4==1){
            if((value[2, 2]==1 & total.3==1) | (value[2, 2]==1 & total.4==1)){
              vector.side <- c(place.na[2, 1], place.na[1, 2], place.na[3, 2], place.na[2, 3])
              rn <- sample(vector.side[!is.na(vector.side)], 1)
              text(rn-3*rn%/%3.5, rn%/%3.5+1, symbol.op, cex=6, font=2)
              place.na[rn-3*rn%/%3.5, rn%/%3.5+1] <<- NA
              value[rn-3*rn%/%3.5, rn%/%3.5+1] <<- 1
            }else{
              matrix.cor <- place.na[c(1, 3), c(1, 3)]
              rn <- sample(matrix.cor[!is.na(matrix.cor)], 1)
              text(rn-3*rn%/%3.5, rn%/%3.5+1, symbol.op, cex=6, font=2)
              place.na[rn-3*rn%/%3.5, rn%/%3.5+1] <<- NA
              value[rn-3*rn%/%3.5, rn%/%3.5+1] <<- 1
            }
          }else{
            if((x==1 & y==2) | (x==3 & y==2)){
              rn <- sample(c(1, 3), 1)
              text(x, rn, symbol.op, cex=6, font=2)
              place.na[x, rn] <<- NA
              value[x, rn] <<- 1
            }else if((x==2 & y==3) | (x==2 & y==1)){
              rn <- sample(c(1, 3), 1)
              text(rn, y, symbol.op, cex=6, font=2)
              place.na[rn, y] <<- NA
              value[rn, y] <<- 1
            }else if((x==1 & y==1) | (x==1 & y==3) | (x==3 & y==1) | (x==3 & y==3)){
              text(-x+4, -y+4, symbol.op, cex=6, font=2)
              place.na[-x+4, -y+4] <<- NA
              value[-x+4, -y+4] <<- 1
            }
          }
        }


        # AI Other Turn


      }else{
        text(x, y, symbol, cex=6, font=2)
        place.na[x, y] <<- NA
        value[x, y] <<- 0
        isGameOver()

        for(i in 1:3){
          total.1 <- 0 ; total.2 <- 0
          for(j in 1:3){
            total.1 <- total.1 + value[i, j]
            total.2 <- total.2 + value[j, i]
          }
          if(total.1==-1 | total.2==-1){
            break
          }
        }
        total.3 <- value[1, 1] + value[2, 2] + value[3, 3]
        total.4 <- value[1, 3] + value[2, 2] + value[3, 1]

        if(all(is.na(place.na))){
          isGameOver()
        }else if(total.1==-1 | total.2==-1 | total.3==-1 | total.4==-1){
          attack()
        }else{
          defend()
        }
      }
    }
  }
  isGameOver()
}


# Allow users to click on program.


click <- function(tic.tac.toe=ttt){
  name <- tic.tac.toe$name
  mode <- tic.tac.toe$mode
  type <- tic.tac.toe$type

  while(length(place.na)==9){
    mouse.at <- locator(n = 1, type = "n")
    #cat(mouse.at$x,"\t",  mouse.at$y, "\n")
    x.at <- round(mouse.at$x)
    y.at <- round(mouse.at$y)
    #cat(x.at,"\t",  y.at, "\n")
    if(all(is.na(place.na))){
      ttt <<- tic.tac.toe(name, mode, type)
    }else if(x.at > 3.5 | x.at < 0.5 | y.at > 3.5 | y.at < 0.5){
      r <<- r + 1
      title(sub=list("Click outside:Quit / inside:Restart", col="deeppink", font=2, cex=2), line=2)
      if(r==2){
        dev.off()
        break
      }
    }else{
      if(r==1){
        ttt <<- tic.tac.toe(name, mode, type)
      }else{
        aim(x.at, y.at)
      }
    }
  }
}


# Play the game


start <- function(name="Name", mode=0, type=0){
  x11()
  ttt <<- tic.tac.toe(name, mode, type)
  click()
}

#start("name", "mode" = 0 - 2, type = 0,1)
