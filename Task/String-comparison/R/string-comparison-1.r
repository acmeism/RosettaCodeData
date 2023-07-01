compare <- function(a, b)
{
  cat(paste(a, "is of type", class(a), "and", b, "is of type", class(b), "\n"))

  if (a < b) cat(paste(a, "is strictly less than", b, "\n"))
  if (a <= b) cat(paste(a, "is less than or equal to", b, "\n"))
  if (a > b) cat(paste(a, "is strictly greater than", b, "\n"))
  if (a >= b) cat(paste(a, "is greater than or equal to", b, "\n"))
  if (a == b) cat(paste(a, "is equal to", b, "\n"))
  if (a != b) cat(paste(a, "is not equal to", b, "\n"))

  invisible()
}

compare('YUP', 'YUP')
compare('BALL', 'BELL')
compare('24', '123')
compare(24, 123)
compare(5.0, 5)
