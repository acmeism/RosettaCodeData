library(png)
img <- readPNG("Unfilledcirc.png")
M <- img[ , , 1]
M <- ifelse(M < 0.5, 0, 1)
image(M, col = c(1, 0))

# https://en.wikipedia.org/wiki/Flood_fill
floodfill <- function(row, col, tcol, rcol) {
  if (tcol == rcol) return()
  if (M[row, col] != tcol) return()
  M[row, col] <<- rcol
  floodfill(row - 1, col    , tcol, rcol) # south
  floodfill(row + 1, col    , tcol, rcol) # north
  floodfill(row    , col - 1, tcol, rcol) # west
  floodfill(row    , col + 1, tcol, rcol) # east
  return("filling completed")
}

options(expressions = 10000)
startrow <- 100; startcol <- 100
floodfill(startrow, startcol, 0, 2)

image(M, col = c(1, 0, 2))
