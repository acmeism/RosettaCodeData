gen_board <- function(n) matrix(data=sample(c(0,1), n^2, replace=TRUE),
                                nrow=n,
                                ncol=n,
                                dimnames=list(1:n, letters[1:n]))

fliprow <- function(mat, n){
  mat[n,] <- !mat[n,]
  return(mat)
}

flipcol <- function(mat, n){
  mat[,n] <- !mat[,n]
  return(mat)
}

bits_game <- function(){
  n <- as.numeric(readline(prompt="Input board size: "))
  board_final <- gen_board(n)
  repeat{
    #Generate a list of between 10 and 15 random moves
    num_moves <- sample(10:15, 1)
    flip_args <- sample(1:n, num_moves, replace=TRUE)
    flip_fns <- sample(list(fliprow, flipcol), num_moves, replace=TRUE)
    gen_move <- function(k){
      function(mat) flip_fns[[k]](mat, flip_args[k])
    }
    rand_moves <- sapply(1:num_moves, gen_move)
    #Now apply them to the final board to generate the initial position
    board_initial <- Reduce(function(x, f) f(x), rand_moves, init=board_final)
    #Make sure initial and final positions aren't the same
    if(!identical(board_initial, board_final)) break
  }
  #Time to start the game!
  cat("\nYour starting position is:\n")
  print(board_initial)
  cat("\nYour target position is:\n")
  print(board_final)
  turns <- 1
  while(!identical(board_initial,board_final)){
    cat("\nTurn ", turns, ":\n", sep="")
    move <- readline(prompt="Enter a row or column name to flip it: ")
    if(move %in% 1:n){
      board_initial <- fliprow(board_initial, move)
      cat("\nThe position is now:\n")
      print(board_initial)
      turns <- turns+1
    }
    else if(move %in% letters[1:n]){
      board_initial <- flipcol(board_initial, which(letters==move))
      cat("\nThe position is now:\n")
      print(board_initial)
      turns <- turns+1
    }
    else cat("\nThat's not a valid move. Try again!\n")
  }
  cat("\nWell done! You finished in", turns-1, "move(s).\n")
}

bits_game()
