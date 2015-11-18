PriorityQueue <- function() {
  keys <- values <- NULL
  insert <- function(key, value) {
    temp <- c(keys, key)
    ord <- order(temp)
    keys <<- temp[ord]
    values <<- c(values, list(value))[ord]
  }
  pop <- function() {
    head <- values[[1]]
    values <<- values[-1]
    keys <<- keys[-1]
    return(head)
  }
  empty <- function() length(keys) == 0
  list(insert = insert, pop = pop, empty = empty)
}

pq <- PriorityQueue()
pq$insert(3, "Clear drains")
pq$insert(4, "Feed cat")
pq$insert(5, "Make tea")
pq$insert(1, "Solve RC tasks")
pq$insert(2, "Tax return")
while(!pq$empty()) {
  print(pq$pop())
}
