#### testing ####

pts <- list(point(0,0), point(10,0), point(10,10), point(0,10),
            point(2.5,2.5), point(7.5,2.5), point(7.5,7.5), point(2.5,7.5),
            point(0,5), point(10,5),
            point(3,0), point(7,0), point(7,10), point(3,10))

polygons <-
  list(
       square = createPolygon(pts, list(c(1,2), c(2,3), c(3,4), c(4,1))),
       squarehole = createPolygon(pts, list(c(1,2), c(2,3), c(3,4), c(4,1), c(5,6), c(6,7), c(7,8), c(8,5))),
       exagon = createPolygon(pts, list(c(11,12), c(12,10), c(10,13), c(13,14), c(14,9), c(9,11)))
      )

testpoints <-
  list(
       point(5,5), point(5, 8), point(-10, 5), point(0,5), point(10,5),
       point(8,5), point(9.9,9.9)
      )

for(p in testpoints) {
  for(polysi in 1:length(polygons)) {
    cat(sprintf("point (%lf, %lf) is %s polygon (%s)\n",
                  p$x, p$y, point_in_polygon(polygons[[polysi]], p), names(polygons[polysi])))
  }
}
