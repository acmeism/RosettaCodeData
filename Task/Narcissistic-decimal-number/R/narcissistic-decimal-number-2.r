generateArmstrong <- function(howMany)
{
  resultCount <- i <- 0
  while(resultCount < howMany)
  {
    #The next line looks terrible, but I know of no better way to convert a large integer in to its digits in R.
    digits <- as.integer(unlist(strsplit(format(i, scientific = FALSE), "")))
    if(i == sum(digits^(length(digits)))) cat("Armstrong number ", resultCount <- resultCount + 1, ": ", format(i, big.mark = ","), "\n", sep = "")
    i <- i + 1
  }
}
generateArmstrong(25)
