PriorityQueue <-
  setRefClass("PriorityQueue",
              fields = list(keys = "numeric", values = "list"),
              methods = list(
                insert = function(key,value) {
                  temp <- c(keys,key)
                  ord <- order(temp)
                  keys <<- temp[ord]
                  values <<- c(values,list(value))[ord]
                },
                pop = function() {
                  head <- values[[1]]
                  keys <<- keys[-1]
                  values <<- values[-1]
                  return(head)
                },
                empty = function() length(keys) == 0
                ))
