IterBinSearch <- function(A, value) {
  low = 1
  high = length(A)
  i = 0
  while ( low <= high ) {
    mid <- floor((low + high)/2)
    if ( A[mid] > value )
      high <- mid - 1
    else if ( A[mid] < value )
      low <- mid + 1
    else
      return(mid)
  }
  NULL
}
