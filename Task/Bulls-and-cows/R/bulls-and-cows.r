bulls_and_cows <- function() {
  target <- sample(9, 4)
  attempts <- 0
  repeat {
    input <- readline("Guess a number with 4 unique non-0 digits (Q to quit): ")
    if (tolower(input) == "q") break
    if (nchar(input) == 4) {
      input <- as.integer(strsplit(input, "")[[1]])
      if (anyNA(input)) {
        cat("Malformed input: non-digit character(s)")
      } else if (sum(input == 0) > 0) {
        cat("Malformed input: contains 0(s)")
      } else if (anyDuplicated(input)) {
        cat("Malformed input: duplicated digits")
      } else {
        bulls <- sum(input == target)
        cows <- sum(input %in% target) - bulls
        cat(bulls, "bull(s) and", cows, "cow(s)\n")
        attempts <- attempts + 1
        if (bulls == 4) {
          cat("You won in", attempts, "attempt(s)!\n")
          break
        }
      }
    } else {
      cat("Malformed input: wrong number of characters")
    }
  }
  cat("Thanks for playing!\n")
}

bulls_and_cows()
