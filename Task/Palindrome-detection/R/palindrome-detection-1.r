palindro <- function(p) {
  if ( nchar(p) == 1 ) {
    return(TRUE)
  } else if ( nchar(p) == 2 ) {
    return(substr(p,1,1) == substr(p,2,2))
  } else {
    if ( substr(p,1,1) == substr(p, nchar(p), nchar(p)) ) {
      return(palindro(substr(p, 2, nchar(p)-1)))
    } else {
      return(FALSE)
    }
  }
}
