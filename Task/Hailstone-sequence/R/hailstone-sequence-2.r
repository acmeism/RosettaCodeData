###Task 1:
collatz <- function(n)
{
  lastIndex <- 1
  output <- lastEntry <- n
  while(lastEntry != 1)
  {
    #Each branch updates lastEntry, lastIndex, and appends a new element to the end of output.
    #Note that the return value of lastIndex <- lastIndex + 1 is lastIndex + 1.
    #You may be surprised that output can be appended to despite starting as just a single number.
    #If so, recall that R's numerics are vectors, meaning that output<-n created a vector of length 1.
    #It's ugly, but efficient.
    if(lastEntry %% 2) lastEntry <- output[lastIndex <- lastIndex + 1] <- 3 * lastEntry + 1
    else lastEntry <- output[lastIndex <- lastIndex + 1] <- lastEntry %/% 2
  }
  output
}

###Task 2:
#Notice how easy it is to access the required elements:
twentySeven <- collatz(27)
cat("The first four elements are:", twentySeven[1:4], "and the last four are:", twentySeven[length(twentySeven) - 3:0], "\n")

###Task 3:
#Notice how a several line long loop can be avoided with R's sapply or Vectorize:
seqLenghts <- sapply(seq_len(99999), function(x) length(collatz(x)))
longest <- which.max(seqLenghts)
cat("The longest sequence before the 100000th is found at n =", longest, "and it has length", seqLenghts[longest], "\n")
#Equivalently, line 1 could have been: seqLenghts <- sapply(Vectorize(collatz)(1:99999), length).
#Another good option would be seqLenghts <- lengths(Vectorize(collatz)(1:99999)).
