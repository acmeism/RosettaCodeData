PriorityQueue <-
    setRefClass("PriorityQueue",
                fields = list(keys = "numeric", values = "list"),
                methods = list(
                    insert = function(key,value) {
                        insert.order <- findInterval(key, keys)
                        keys <<- append(keys, key, insert.order)
                        values <<- append(values, value, insert.order)
                    },
                    pop = function() {
                        head <- list(key=keys[1],value=values[[1]])
                        keys <<- keys[-1]
                        values <<- values[-1]
                        return(head)
                    },
                    empty = function() length(keys) == 0
                ))
