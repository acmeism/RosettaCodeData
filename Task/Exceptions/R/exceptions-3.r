tryCatch(
  {
    if(runif(1) > 0.5)
    {
      message("This doesn't throw an error")
    } else
    {
      stop("This is an error")
    }
  },
  error = function(e) message(paste("An error occured", e$message, sep = ": ")),
  finally = message("This is called whether or not an exception occured")
)
