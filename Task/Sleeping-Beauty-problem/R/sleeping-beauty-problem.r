beautyProblem <- function(n)
{
  wakeCount <- headCount <- 0
  for(i in seq_len(n))
  {
    wakeCount <- wakeCount + 1
    if(sample(c("H", "T"), 1) == "H") headCount <- headCount + 1 else wakeCount <- wakeCount + 1
  }
  headCount/wakeCount
}
print(beautyProblem(10000000))
