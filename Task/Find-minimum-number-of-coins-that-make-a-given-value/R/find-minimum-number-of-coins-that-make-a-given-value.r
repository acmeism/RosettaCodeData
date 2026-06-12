coins <- c(200, 100, 50, 20, 10, 5, 2, 1)
change <- function(n){
  nums <- numeric(length(coins))
  for(i in seq_along(coins)){
    nums[i] <- n%/%coins[i]
    n <- n%%coins[i]
  }
  nums
}

paste(change(988), "coin(s) of value", coins) |> writeLines()
