F yinyang(n = 3)
   V radii = [1, 3, 6].map(i -> i * @n)
   V ranges = radii.map(r -> Array(-r .. r))
   V squares = ranges.map(rnge -> multiloop(rnge, rnge, (x, y) -> (x, y)))
   V circles = zip(squares, radii).map((sqrpoints, radius) -> sqrpoints.filter((x, y) -> x*x + y*y <= @radius^2))
   V m = Dict(squares.last, (x, y) -> ((x, y), ‘ ’))
   L(x, y) circles.last
      m[(x, y)] = ‘*’
   L(x, y) circles.last
      I x > 0
         m[(x, y)] = ‘·’
   L(x, y) circles[(len)-2]
      m[(x, y + 3 * n)] = ‘*’
      m[(x, y - 3 * n)] = ‘·’
   L(x, y) circles[(len)-3]
      m[(x, y + 3 * n)] = ‘·’
      m[(x, y - 3 * n)] = ‘*’
   R ranges.last.map(y -> reversed(@ranges.last).map(x -> @@m[(x, @y)]).join(‘’)).join("\n")

print(yinyang(2))
print(yinyang(1))
