colours <- c("Red", "White", "Blue")

rand_balls <- function(v, f){
  repeat{
    balls <- sample(v, sample(10:20, 1), replace=TRUE)
    balls_sorted <- f(balls)
    if(!identical(balls, balls_sorted)){
      print(list("Unsorted"=balls, "Sorted"=balls_sorted), quote=FALSE)
      break
    }
  }
}

#Method 1: converting the vector of colours to a factor and using the built-in sort() function

colours_ordered <- factor(1:3, labels=colours)
rand_balls(colours_ordered, sort)

#Method 2: simple counting sort (showcasing the conciseness of R's rep() function)

counting_sort <- function(v){
 counts <- sapply(1:3, function(n) sum(v==colours[n]))
 rep(colours, times=counts)
}

rand_balls(colours, counting_sort)
