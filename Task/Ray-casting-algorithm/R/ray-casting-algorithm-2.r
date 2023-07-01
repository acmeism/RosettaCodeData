######## utility functions #########

point <- function(x,y) list(x=x, y=y)

# pts = list(p1, p2, ... )... coords
# segs = list(c(1,2), c(2,1) ...) indices
createPolygon <- function(pts, segs) {
  pol <- list()
  for(pseg in segs) {
    pol <- c(pol, list(list(A=pts[[pseg[1]]], B=pts[[pseg[2]]])))
  }
  pol
}
