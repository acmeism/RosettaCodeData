 printallargs2 <- function(...)
 {
   args <- list(...)
   lapply(args, print)
   invisible()
 }
 printallargs2(1:5, "abc", TRUE)
# [1] 1 2 3 4 5
# [1] "abc"
# [1] TRUE
