reversalGame <- function(){
  cat("Welcome to the Number Reversal Game! \n")
  cat("Sort the numbers into ascending order by repeatedly \n",
      "reversing the first n digits, where you specify n. \n \n", sep="")

  # Generate a list that's definitely not in ascending order, per instuctions
  data <- sample(1:9, 9)
  while (all(data == 1:9)){
    cat("What were the chances...? \n")
    data <- sample(1:9, 9)
  }
  trials <- 0

  # Play the game
  while (any(data != 1:9)){
    trials <- trials + 1
    cat("Trial", sprintf("%02d", trials), " # ", data, " #  ")
    answer <- readline(paste("Flip how many? "))
    data[1:answer] <- data[answer:1]
  }

  # Victory!
  cat("Well done.  You needed", trials, "flips. \n")
}
