 def pythagoranTriangles(n: Int) = (1 to n) flatMap (x =>
  (x to n) flatMap (y =>
    (y to n) filter (z => x * x + y * y == z * z) map (z =>
      (x, y, z))))
