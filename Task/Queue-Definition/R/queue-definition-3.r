library(proto)

fifo <- proto(expr = {
   l <- list()
   empty <- function(.) length(.$l) == 0
   push <- function(., x)
   {
      .$l <- c(.$l, list(x))
      print(.$l)
      invisible()
   }
   pop <- function(.)
   {
      if(.$empty()) stop("can't pop from an empty list")
      .$l[[1]] <- NULL
      print(.$l)
      invisible()
   }
})

#The following code provides output that is the same as the previous example.
fifo$empty()
fifo$push(3)
fifo$push("abc")
fifo$push(matrix(1:6, nrow=2))
fifo$empty()
fifo$pop()
fifo$pop()
fifo$pop()
fifo$pop()
