coconutsProblem <- function(sailorCount)
{
  stopifnot(sailorCount > 1) #Problem makes no sense otherwise
  initalCoconutCount <- sailorCount
  repeat
  {
    initalCoconutCount <- initalCoconutCount + 1
    coconutCount <- initalCoconutCount
    for(i in seq_len(sailorCount))
    {
      if(coconutCount %% sailorCount != 1) break
      coconutCount <- (coconutCount - 1) * (sailorCount - 1)/sailorCount
      if(i == sailorCount && coconutCount > 0 && coconutCount %% sailorCount == 0) return(initalCoconutCount)
    }
  }
}
print(data.frame("Sailors" = 2:8, "Coconuts" = sapply(2:8, coconutsProblem)))
