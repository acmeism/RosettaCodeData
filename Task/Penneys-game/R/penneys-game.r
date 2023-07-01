#===============================================================
# Penney's Game Task from Rosetta Code Wiki
# R implementation
#===============================================================

penneysgame <- function() {

  #---------------------------------------------------------------
  # Who goes first?
  #---------------------------------------------------------------

  first <- sample(c("PC", "Human"), 1)

  #---------------------------------------------------------------
  # Determine the sequences
  #---------------------------------------------------------------

  if (first == "PC") { # PC goes first

    pc.seq <- sample(c("H", "T"), 3, replace = TRUE)
    cat(paste("\nI choose first and will win on first seeing", paste(pc.seq, collapse = ""), "in the list of tosses.\n\n"))
    human.seq <- readline("What sequence of three Heads/Tails will you win with: ")
    human.seq <- unlist(strsplit(human.seq, ""))

  } else if (first == "Human") { # Player goest first

    cat(paste("\nYou can choose your winning sequence first.\n\n"))
    human.seq <- readline("What sequence of three Heads/Tails will you win with: ")
    human.seq <- unlist(strsplit(human.seq, "")) # Split the string into characters
    pc.seq <- c(human.seq[2], human.seq[1:2]) # Append second element at the start
    pc.seq[1] <- ifelse(pc.seq[1] == "H", "T", "H") # Switch first element to get the optimal guess
    cat(paste("\nI win on first seeing", paste(pc.seq, collapse = ""), "in the list of tosses.\n"))

  }

  #---------------------------------------------------------------
  # Start throwing the coin
  #---------------------------------------------------------------

  cat("\nThrowing:\n")

  ran.seq <- NULL

  while(TRUE) {

    ran.seq <- c(ran.seq, sample(c("H", "T"), 1)) # Add a new coin throw to the vector of throws

    cat("\n", paste(ran.seq, sep = "", collapse = "")) # Print the sequence thrown so far

    if (length(ran.seq) >= 3 && all(tail(ran.seq, 3) == pc.seq)) {
      cat("\n\nI win!\n")
      break
    }

    if (length(ran.seq) >= 3 && all(tail(ran.seq, 3) == human.seq)) {
      cat("\n\nYou win!\n")
      break
    }

    Sys.sleep(0.5) # Pause for 0.5 seconds

  }
}
