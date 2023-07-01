rValues <- 1
sValues <- 2
ffr <- function(n)
{
  if(!is.na(rValues[n])) rValues[n] else (rValues[n] <<- ffr(n-1) + ffs(n-1))
}

#In theory, generating S requires computing ALL values not in R.
#That would be infinitely many values.
#However, to generate S(n) we only need to observe that its value cannot exceed R(n)+1.
ffs <- function(n)
{
  if(!is.na(sValues[n])) sValues[n] else (sValues[n] <<- setdiff(seq_len(1 + ffr(n)), rValues)[n])
}

#Task 1
invisible(ffr(10))
print(rValues)

#Task 2
#If we try to call ffs(960) directly, R will complain about the stack being too big.
#Calling ffs(500) first solves this problem.
invisible(ffs(500))
invisible(ffs(960))
#In R, "the first 40 values of ffr plus the first 960 values of ffs" can easily be misread.
#rValues[1:40]+sValues[1:960] is valid R code. It will duplicate the first 40 rValues 23
#times, append them to the original, and add that vector to the first 960 sValues.
This gives an output of length 960, which clearly cannot contain 1000 different values.
#Presumably, the task wants us to append rValues[1:40] and sValues[1:960].
print(table(c(rValues[1:40], sValues[1:960])))
