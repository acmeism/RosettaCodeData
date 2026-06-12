as.string <- function(...){
  s <- paste0(..., collapse="")
  class(s) <- "string"
  return(s)
}

`+.string` <- function(s1, s2) as.string(s1, s2)

print.string <- function(s, quote=TRUE){
  q <- rep("\"", quote)
  cat(q, s, q, "\n", sep="")
}

1+2
as.string(1)+as.string(2)
