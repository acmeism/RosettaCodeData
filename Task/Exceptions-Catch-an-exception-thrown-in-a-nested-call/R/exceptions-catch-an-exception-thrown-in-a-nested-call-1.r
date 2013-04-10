number_of_calls_to_baz <- 0

foo <- function()
{
   for(i in 1:2) tryCatch(bar())
}

bar <- function() baz()

baz <- function()
{
   e <- simpleError(ifelse(number_of_calls_to_baz > 0, "U1", "U0"))
   assign("number_of_calls_to_baz", number_of_calls_to_baz + 1, envir=globalenv())
   stop(e)
}
