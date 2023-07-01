entropy <- function(s)
{
  if (length(s) > 1)
    return(sapply(s, entropy))

  freq <- prop.table(table(strsplit(s, '')[1]))
  ret <- -sum(freq * log(freq, base=2))

  return(ret)
}

fibwords <- function(n)
{
  if (n == 1)
    fibwords <- "1"
  else
    fibwords <- c("1", "0")

  if (n > 2)
  {
    for (i in 3:n)
      fibwords <- c(fibwords, paste(fibwords[i-1L], fibwords[i-2L], sep=""))
  }

  str <- if (n > 7) replicate(n-7, "too long") else NULL
  fibwords.print <- c(fibwords[1:min(n, 7)], str)

  ret <- data.frame(Length=nchar(fibwords), Entropy=entropy(fibwords), Fibwords=fibwords.print)
  rownames(ret) <- NULL
  return(ret)
}
