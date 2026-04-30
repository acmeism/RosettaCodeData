assignVec <- Vectorize("assign", c("x", "value"))
`%<<-%` <- function(x, value) invisible(assignVec(x, value, envir = .GlobalEnv)) # define multiple global assignments operator

x <- 'lions, tigers, and'
y <- 'bears, oh my!'
z <- '(from the "Wizard of OZ")'

c("x", "y", "z") %<<-% sort(c(x, y, z))

x <- 77444
y <-   -12
z <-     0

c("x", "y", "z") %<<-% sort(c(x, y, z))
