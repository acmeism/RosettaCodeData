isPrime <- function(n) {
  if (n == 2) return(TRUE)
  if ( (n <= 1) || ( n %% 2 == 0 ) ) return(FALSE)
  for( i in 3:sqrt(n) ) {
    if ( n %% i == 0 ) return(FALSE)
  }
  TRUE
}
