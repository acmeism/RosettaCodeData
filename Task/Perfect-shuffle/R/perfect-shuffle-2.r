#A strict reading of the task description says that we need a function that does exactly one shuffle.
pShuffle <- function(deck)
{
  n <- length(deck)#Assumed even (as in task description).
  shuffled <- array(n)#Maybe not as general as it could be, but the task said to use whatever was convenient.
  shuffled[seq(from = 1, to = n, by = 2)] <- deck[seq(from = 1, to = n/2, by = 1)]
  shuffled[seq(from = 2, to = n, by = 2)] <- deck[seq(from = 1 + n/2, to = n, by = 1)]
  shuffled
}

task2 <- function(deck)
{
  shuffled <- deck
  count <- 0
  repeat
  {
    shuffled <- pShuffle(shuffled)
    count <- count + 1
    if(all(shuffled == deck)) break
  }
  cat("It takes", count, "shuffles of a deck of size", length(deck), "to return to the original deck.","\n")
  invisible(count)#For the unit tests. The task wanted this printed so we only return it invisibly.
}

#Tests - All done in one line.
mapply(function(x, y) task2(1:x) == y, c(8, 24, 52, 100, 1020, 1024, 10000), c(3, 11, 8, 30, 1018, 10, 300))
