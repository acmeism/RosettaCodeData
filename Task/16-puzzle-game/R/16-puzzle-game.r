target_board <- matrix(data=1:16, nrow=4, ncol=4, byrow=TRUE)

rotate_rowcol <- function(mat, n, direction){
  switch(direction,
         "left"=eval(mat[n,] <- c(mat[n,-1], mat[n,1])),
         "right"=eval(mat[n,] <- c(mat[n,nrow(mat)], mat[n,-nrow(mat)])),
         "up"=eval(mat[,n] <- c(mat[-1,n], mat[1,n])),
         "down"=eval(mat[,n] <- c(mat[ncol(mat),n], mat[-ncol(mat),n])))
  return(mat)
}

sixteen_game <- function(){
  repeat{
    difficulty <- tolower(readline(prompt="Choose difficulty level (easy or hard): "))
    if(difficulty %in% c("easy","hard")) break
    cat("\nThat's not a valid difficulty. Try again!\n")
  }
  maxmoves <- switch(difficulty, "easy"=3, "hard"=12)
  dirs <- sample(c("left","right","up","down"), maxmoves)
  nums <- sample(c(1:4), maxmoves)
  funs <- sapply(1:maxmoves, function(k) function(mat) rotate_rowcol(mat, nums[k], dirs[k]))
  initial_board <- Reduce(function(x, f) f(x), funs, init=target_board)
  print(initial_board)
  turns <- 1
  while(!identical(initial_board, target_board)){
    cat("\nTurn ", turns, ":\n", sep="")
    d <- tolower(readline(prompt="Choose a direction to rotate (up, down, left, or right): "))
    if(d %in% c("left","right")){
      index <- as.numeric(readline(prompt="Enter a row number: "))
      initial_board <- rotate_rowcol(initial_board, index, d)
      print(initial_board)
      turns <- turns+1
    }
    else if(d %in% c("up","down")){
      index <- as.numeric(readline(prompt="Enter a column number: "))
      initial_board <- rotate_rowcol(initial_board, index, d)
      print(initial_board)
      turns <- turns+1
    }
    else cat("\nThat's not a valid direction. Try again!\n")
  }
  cat("\nWell done! You finished in", turns-1, "move(s).\n")
}

sixteen_game()
