text_maze <- function() {
  xp <- yp <- 127
  na <- 0
  x <- y <- e <- c()
  d <- -1
  f <- sample(4, 1)
  repeat {
    a <- na + 1
    for(n in seq_len(na)) {
      if(x[n] == xp && y[n] == yp) {
        a <- n
        break
      }
    }
    if(a == na + 1) {
      na <- na + 1
      x <- c(x, xp)
      y <- c(y, yp)
      e <- c(e, sample(c(TRUE, FALSE), 4, replace = TRUE))
      for(n in seq_len(na)) {
        if(x[n] == x[a] + 1 && y[n] == y[a]) {
          e[4*(a - 1) + 1] <- e[4*(n - 1) + 3]
        }
        if(x[n] == x[a] && y[n] == y[a] + 1) {
          e[4*(a - 1) + 2] <- e[4*(n - 1) + 4]
        }
        if(x[n] == x[a] - 1 && y[n] == y[a]) {
          e[4*(a - 1) + 3] <- e[4*(n - 1) + 1]
        }
        if(x[n] == x[a] && y[n] == y[a] - 1) {
          e[4*(a - 1) + 4] <- e[4*(n - 1) + 2]
        }
      }
    }
    cat("Paths:")
    paths <- c(" ahead", " right", " back", " left")
    if(e[4*(a - 1) + f]) cat(paths[1])
    for(i in 1:3) {
      if(e[1 + 4*(a - 1) + (f - 1 + i)%%4]) cat(paths[i+1])
    }
    d <- -1
    while(d < 0) {
      entry <- readline("> ")
      switch(entry,
             "ahead" = eval(d <- f),
             "right" = eval(d <- 1 + f%%4),
             "back" = eval(d <- 1 + (f + 1)%%4),
             "left" = eval(d <- 1 + (f + 2)%%4),
             "exit" = eval(if(xp == 127 && yp == 127) d <- 5 else cat("You are not at the exit.\n")),
             "quit" = eval(d <- 5),
             cat("Invalid entry.\n"))
    }
    switch(d,
           ifelse(e[4*(a - 1) + 1], eval(xp <- xp + 1), eval(d <- -1)),
           ifelse(e[4*(a - 1) + 2], eval(yp <- yp + 1), eval(d <- -1)),
           ifelse(e[4*(a - 1) + 3], eval(xp <- xp - 1), eval(d <- -1)),
           ifelse(e[4*(a - 1) + 4], eval(yp <- yp - 1), eval(d <- -1)))

    if(d < 0) {
      cat("No path.\n")
    } else if(d == 5) {
      cat("You have exited the maze. Or just quit the program.\n")
      break
    } else d <- f
  }
}

text_maze()
