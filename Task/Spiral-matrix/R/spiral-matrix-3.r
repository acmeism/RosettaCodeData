spiralMatrix <- function(n)
{
  spiral <- matrix(0, nrow = n, ncol = n)
  firstNumToWrite <- 0
  neededLength <- n
  startPt <- cbind(1, 0)#(1, 0) is needed for the first call to writeRight to work. We need to start in row 1.
  writingDirectionIndex <- 0
  #These two functions select a collection of adjacent elements and replaces them with the needed sequence.
  #This heavily uses R's vector recycling rules.
  writeDown <- function(seq) spiral[startPt[1] + seq, startPt[2]] <<- seq_len(neededLength) - 1 + firstNumToWrite
  writeRight <- function(seq) spiral[startPt[1], startPt[2] + seq] <<- seq_len(neededLength) - 1 + firstNumToWrite
  while(firstNumToWrite != n^2)
  {
    writingDirectionIndex <- writingDirectionIndex %% 4 + 1
    seq <- seq_len(neededLength)
    switch(writingDirectionIndex,
           writeRight(seq),
           writeDown(seq),
           writeRight(-seq),
           writeDown(-seq))
    if(writingDirectionIndex %% 2) neededLength <- neededLength - 1
    max <- max(spiral)
    firstNumToWrite <- max + 1
    startPt <- which(max == spiral, arr.ind = TRUE)
  }
  spiral
}
