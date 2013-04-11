empty <- function() length(l) == 0
push <- function(x)
{
   l <<- c(l, list(x))
   print(l)
   invisible()
}
pop <- function()
{
   if(empty()) stop("can't pop from an empty list")
   l[[1]] <<- NULL
   print(l)
   invisible()
}
l <- list()
empty()
# [1] TRUE
push(3)
# [[1]]
# [1] 3
push("abc")
# [[1]]
# [1] 3
# [[2]]
# [1] "abc"
push(matrix(1:6, nrow=2))
# [[1]]
# [1] 3
# [[2]]
# [1] "abc"
# [[3]]
#      [,1] [,2] [,3]
# [1,]    1    3    5
# [2,]    2    4    6
empty()
# [1] FALSE
pop()
# [[1]]
# [1] 3
# [[2]]
# [1] "abc"
pop()
# [[1]]
# [1] 3
pop()
# list()
pop()
# Error in pop() : can't pop from an empty list
