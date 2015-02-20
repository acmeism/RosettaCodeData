nth <- function(n)
{
  if (length(n) > 1) return(sapply(n, nth))

  mod <- function(m, n) ifelse(!(m%%n), n, m%%n)
  suffices <- c("th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th")

  if (n %% 100 <= 10 || n %% 100 > 20)
    suffix <- suffices[mod(n+1, 10)]
  else
    suffix <- 'th'

  paste(n, "'", suffix, sep="")
}

range <- list(0:25, 250:275, 500:525, 750:775, 1000:1025)

sapply(range, nth)
