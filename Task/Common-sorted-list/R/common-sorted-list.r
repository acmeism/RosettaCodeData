csl <- function(nums) Reduce(union, nums) |> sort()

csl(list(c(5,1,3,8,9,4,8,7), c(3,5,9,8,4), c(1,3,7,9)))
