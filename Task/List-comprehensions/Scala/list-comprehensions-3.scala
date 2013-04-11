def pythagoranTriangles(n: Int) = for {
  x <- List.range(1, n + 1)
  y <- x to 21
  z <- y to 21
  if x * x + y * y == z * z
} yield (x, y, z)
