tRange <- function(aRange, bRange, s)
{
  #Guard clauses. We could write some proper error messages, but this is all we really need.
  stopifnot(length(aRange) == 2, length(bRange) == 2,
            is.numeric(aRange), is.numeric(bRange), is.numeric(s),
            s >= aRange[1], s <= aRange[2])
  bRange[1] + ((s - aRange[1]) * (bRange[2] - bRange[1])) / (aRange[2] - aRange[1])
}
data.frame(s = 0:10, t = sapply(0:10, tRange, aRange = c(0, 10), bRange = c(-1, 0)))
