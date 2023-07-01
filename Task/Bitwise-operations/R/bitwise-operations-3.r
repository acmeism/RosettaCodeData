intToLogicalBits <- function(intx) as.logical(intToBits(intx))
logicalBitsToInt <- function(lb) as.integer(sum((2^(0:31))[lb]))
"%AND%" <- function(x, y)
{
   logicalBitsToInt(intToLogicalBits(x) & intToLogicalBits(y))
}
"%OR%" <- function(x, y)
{
   logicalBitsToInt(intToLogicalBits(x) | intToLogicalBits(y))
}

35 %AND% 42    # 34
35 %OR% 42     # 42
