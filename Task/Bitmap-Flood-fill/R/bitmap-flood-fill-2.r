library(png)
img <- readPNG("Unfilledcirc.png")
M <- img[ , , 1]
M <- ifelse(M < 0.5, 0, 1)
M <- rbind(M, 0)
M <- cbind(M, 0)
image(M, col = c(1, 0))

# https://en.wikipedia.org/wiki/Flood_fill
floodfill <- function(row, col, tcol, rcol) {
  if (tcol == rcol) return()
  if (M[row, col] != tcol) return()
  Q <- matrix(c(row, col), 1, 2)
  while (dim(Q)[1] > 0) {
    n <- Q[1, , drop = FALSE]
    west  <- cbind(n[1]    , n[2] - 1)
    east  <- cbind(n[1]    , n[2] + 1)
    north <- cbind(n[1] + 1, n[2]    )
    south <- cbind(n[1] - 1, n[2]    )
    Q <- Q[-1, , drop = FALSE]
    if (M[n] == tcol) {
      M[n] <<- rcol
      if (M[west] == tcol)  Q <- rbind(Q, west)
      if (M[east] == tcol)  Q <- rbind(Q, east)
      if (M[north] == tcol) Q <- rbind(Q, north)
      if (M[south] == tcol) Q <- rbind(Q, south)
    }
  }
  return("filling completed")
}

startrow <- 100; startcol <- 100
floodfill(startrow, startcol, 0, 2)
startrow <- 50; startcol <- 50
floodfill(startrow, startcol, 1, 3)

image(M, col = c(1, 0, 2, 3))
