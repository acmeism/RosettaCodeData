def pythagoranTriangles(n: Int) = for {
  x <- 1 to 21
  y <- x to 21
  z <- y to 21
  if x * x + y * y == z * z
} yield (x, y, z)
