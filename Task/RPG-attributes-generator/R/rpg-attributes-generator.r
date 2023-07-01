genStats <- function()
{
  stats <- c(STR = 0, DEX = 0, CON = 0, INT = 0, WIS = 0, CHA = 0)
  for(i in seq_along(stats))
  {
    results <- sample(6, 4, replace = TRUE)
    stats[i] <- sum(results[-which.min(results)])
  }
  if(sum(stats >= 15) <  2 || (stats["TOT"] <- sum(stats)) < 75) Recall() else stats
}
print(genStats())
