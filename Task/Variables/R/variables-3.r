a <- 3

assignmentdemo <- function()
{
   message("assign 'a' locally, i.e. within the scope of the function")
   a <- 5
   message(paste("inside assignmentdemo, a = ", a))
   message(paste("in the global environment, a = ", get("a", envir=globalenv())))

   message("assign 'a' globally")
   a <<- 7
   message(paste("inside assignmentdemo, a = ", a))
   message(paste("in the global environment, a = ", get("a", envir=globalenv())))
}
assignmentdemo()
