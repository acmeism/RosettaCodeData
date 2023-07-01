step <- function() {
    success <- runif(1) > p
    ## Requires that the "robot" is a variable named "level"
    level <<- level - 1 + (2 * success)
    success
}
