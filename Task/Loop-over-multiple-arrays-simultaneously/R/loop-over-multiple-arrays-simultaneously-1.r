multiloop <- function(...)
{
   # Retrieve inputs and convert to a list of character strings
   arguments <- lapply(list(...), as.character)

   # Get length of each input
   lengths <- sapply(arguments, length)

   # Loop over elements
   for(i in seq_len(max(lengths)))
   {
      # Loop over inputs
      for(j in seq_len(nargs()))
      {
         # print a value or a space (if that input has finished)
         cat(ifelse(i <= lengths[j], arguments[[j]][i], " "))
      }
      cat("\n")
   }
}
multiloop(letters[1:3], LETTERS[1:3], 1:3)
