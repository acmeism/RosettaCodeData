cocktailSort <- function(A)
{
  repeat
  {
    swapped <- FALSE
    for(i in seq_len(length(A) - 1))
    {
      if(A[i] > A[i + 1])
      {
        A[c(i, i + 1)] <- A[c(i + 1, i)]#The cool trick mentioned above.
        swapped <- TRUE
      }
    }
    if(!swapped) break
    swapped <- FALSE
    for(i in (length(A)-1):1)
    {
      if(A[i] > A[i + 1])
      {
        A[c(i, i + 1)] <- A[c(i + 1, i)]
        swapped <- TRUE
      }
    }
    if(!swapped) break
  }
  A
}
#Examples taken from the Haxe solution.
ints <- c(1, 10, 2, 5, -1, 5, -19, 4, 23, 0)
numerics <- c(1, -3.2, 5.2, 10.8, -5.7, 7.3, 3.5, 0, -4.1, -9.5)
strings <- c("We", "hold", "these", "truths", "to", "be", "self-evident", "that", "all", "men", "are", "created", "equal")
