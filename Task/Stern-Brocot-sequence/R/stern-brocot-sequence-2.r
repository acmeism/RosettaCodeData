genNStern <- function(n)
{
  sternNums <- c(1, 1)
  i <- 2
  while((endIndex <- length(sternNums)) < n)
  {
    #To show off R's vectorization, the following line is deliberately terse.
    #It assigns sternNums[i-1]+sternNums[i] to sternNums[endIndex+1]
    #and it assigns sternNums[i], the "considered" number, to sternNums[endIndex+2], now the end of the sequence.
    #Note that we do not have to initialize a big sternNums array to do this.
    #True to the algorithm, the new entries are appended to the end of the old sequence.
    sternNums[endIndex + c(1, 2)] <- c(sum(sternNums[c(i - 1, i)]), sternNums[i])
    i <- i + 1
  }
  sternNums[seq_len(n)]
}
#N=5000 was picked arbitrarily. The code runs very fast regardless of this number being much more than we need.
firstFiveThousandTerms <- genNStern(5000)
match(1:10, firstFiveThousandTerms)
match(100, firstFiveThousandTerms)
all(sapply(1:999, function(i) gmp::gcd(firstFiveThousandTerms[i], firstFiveThousandTerms[i + 1])) == 1)
