PriorityQueue <- function() {
  keys <- values <- NULL
  insert <- function(key, value) {
    ord <- findInterval(key, keys)
    keys <<- append(keys, key, ord)
    values <<- append(values, value, ord)
  }
  pop <- function() {
    head <- list(key=keys[1],value=values[[1]])
    values <<- values[-1]
    keys <<- keys[-1]
    return(head)
  }
  empty <- function() length(keys) == 0
  environment()
}

pq <- PriorityQueue()
pq$insert(3, "Clear drains")
pq$insert(4, "Feed cat")
pq$insert(5, "Make tea")
pq$insert(1, "Solve RC tasks")
pq$insert(2, "Tax return")
while(!pq$empty()) {
  with(pq$pop(), cat(key,":",value,"\n"))
}
