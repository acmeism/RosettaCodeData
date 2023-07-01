compare <- function(a, b)
{
  cat(paste(a, "is of type", class(a), "and", b, "is of type", class(b), "\n"))

  printer <- function(a, b, msg) cat(paste(a, msg, b, "\n"))

  op <- c(`<`, `<=`, `>`, `>=`, `==`, `!=`)
  msgs <- c(
    "is strictly less than",
    "is less than or equal to",
    "is strictly greater than",
    "is greater than or equal to",
    "is equal to",
    "is not equal to"
  )

  sapply(1:length(msgs), function(i) if(op[[i]](a, b)) printer(a, b, msgs[i]))

  invisible()
}
