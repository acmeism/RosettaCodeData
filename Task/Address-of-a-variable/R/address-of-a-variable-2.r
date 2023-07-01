address <- function(obj) {
  paste0("0x", substring(sub(" .*$","",capture.output(.Internal(inspect(obj)))),2))
}

x <- 5
y <- x
address(x)
address(y)

y <- y + 1
address(x)
address(y)
