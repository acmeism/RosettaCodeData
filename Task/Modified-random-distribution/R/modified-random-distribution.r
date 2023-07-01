library(NostalgiR) #For the textual histogram.
modifier <- function(x) 2*abs(x - 0.5)
gen <- function()
{
  repeat
  {
    random <- runif(2)
    if(random[2] < modifier(random[1])) return(random[1])
  }
}
data <- replicate(100000, gen())
NostalgiR::nos.hist(data, breaks = 20, pch = "#")
