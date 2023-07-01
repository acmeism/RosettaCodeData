josephusProblem <- function(n, k, m)
{
  prisoners <- 0:(n - 1)
  exPos <- countToK <- 1
  dead <- integer(0)
  while(length(prisoners) > m)
  {
    if(countToK == k)
    {
      dead <- c(dead, prisoners[exPos])
      prisoners <- prisoners[-exPos]
      exPos <- exPos - 1
    }
    exPos <- exPos + 1
    countToK <- countToK + 1
  if(exPos > length(prisoners)) exPos <- 1
  if(countToK > k) countToK <- 1
  }
  print(paste0("Execution order: ", paste0(dead, collapse = ", "), "."))
  paste0("Survivors: ", paste0(prisoners, collapse = ", "), ".")
}
