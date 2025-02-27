quickselect <- function(vec, k) {
  stopifnot(k > 0, k <= length(vec))
  repeat {
    pivot_index <- sample.int(length(vec), 1)
    pivot_value <- vec[[pivot_index]]
    left <- vec[vec < pivot_value]
    right <- vec[vec > pivot_value]
    pivot_index <- length(left) + 1
    if (k == pivot_index) {
      return(pivot_value)
    } else if (k < pivot_index) {
      vec <- left
    } else {
      k <- k - pivot_index
      vec <- right
    }
  }
}

vec <- c(9, 8, 7, 6, 5, 0, 1, 2, 3, 4)
print(sapply(1:10, quickselect, vec = vec))
