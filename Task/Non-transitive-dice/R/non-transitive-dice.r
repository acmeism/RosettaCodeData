findNonTrans <- function()
{
  diceSet <- unique(t(apply(expand.grid(1:4, 1:4, 1:4, 1:4), 1, sort))) #By construction, each row is a unique dice.
  winningDice <- function(X, Y) #Recall 'Example 1' in the task.
  {
    comparisonTable <- data.frame(X = rep(X, each = length(X)), Y = rep(Y, times = length(Y)))
    rowWinner <- ifelse(comparisonTable["X"] > comparisonTable["Y"], "X",
                        ifelse(comparisonTable["X"] == comparisonTable["Y"], "-", "Y"))
    netXWins <- sum(rowWinner == "X") - sum(rowWinner == "Y")
    if(netXWins > 0) "X" else if(netXWins == 0) "Draw" else "Y"
  }
  rows <- seq_len(nrow(diceSet)) #Recall that each row of diceSet is a dice.
  XvsAllY <- function(X) sapply(rows, function(i) winningDice(X, diceSet[i, ]))
  winners <- as.data.frame(lapply(rows, function(i) XvsAllY(diceSet[i, ])),
                row.names = paste("Y=Dice", rows), col.names = paste("X=Dice", rows), check.names = FALSE)
  solutionCount <- 0
  for(S in rows)
  {
    beatsS <- which(winners[paste("X=Dice", S)] == "Y") #Finds the indices of all T such that S<T.
    beatsT <- lapply(beatsS, function(X) which(winners[paste("X=Dice", X)] == "Y")) #To begin finding U such that T<U.
    beatenByS <- which(winners[paste("X=Dice", S)] == "X") #Finds the indices of all U such that S>U.
    potentialU <- lapply(beatsT, function(X) intersect(X, beatenByS)) #Combining previous two lines.
    nonEmptyIndices <- lengths(potentialU) != 0 #Most of potentialU is usually empty lists.
    if(any(nonEmptyIndices)) #If any lists in potentialU are non-empty, then their entry is the index of a U with S>U & T<U.
    {
      solutionCount <- solutionCount + 1
      diceUIndex <- potentialU[nonEmptyIndices][[1]] #Assumes that there is only one valid U for this S.
      diceTIndex <- beatsS[nonEmptyIndices][[1]] #Finds the T corresponding to the chosen U.
      cat("Solution", solutionCount, "is:\n")
      output <- rbind(S = diceSet[S,], T = diceSet[diceTIndex,], U = diceSet[diceUIndex,])
      colnames(output) <- paste("Dice", 1:4)
      print(output)
    }
  }
}
findNonTrans()
