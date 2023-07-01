#lang R

assignVec <- Vectorize("assign", c("x", "value"))
`%<<-%` <- function(x, value) invisible(assignVec(x, value, envir = .GlobalEnv)) # define multiple global assignments operator
