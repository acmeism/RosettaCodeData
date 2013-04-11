class Circle
  constructor: (@x, @y, @r) ->

apollonius = (c1, c2, c3, s1=1, s2=1, s3=1) ->
  [x1, y1, r1] = [c1.x, c1.y, c1.r]
  [x2, y2, r2] = [c2.x, c2.y, c2.r]
  [x3, y3, r3] = [c3.x, c3.y, c3.r]

  sq = (n) -> n*n

  v11 = 2*x2 - 2*x1
  v12 = 2*y2 - 2*y1
  v13 = sq(x1) - sq(x2) + sq(y1) - sq(y2) - sq(r1) + sq(r2)
  v14 = 2*s2*r2 - 2*s1*r1

  v21 = 2*x3 - 2*x2
  v22 = 2*y3 - 2*y2
  v23 = sq(x2) - sq(x3) + sq(y2) - sq(y3) - sq(r2) + sq(r3)
  v24 = 2*s3*r3 - 2*s2*r2

  w12 = v12/v11
  w13 = v13/v11
  w14 = v14/v11

  w22 = v22/v21 - w12
  w23 = v23/v21 - w13
  w24 = v24/v21 - w14

  p = -w23/w22
  q = w24/w22
  m = -w12*p - w13
  n = w14 - w12*q

  a = sq(n) + sq(q) - 1
  b = 2*m*n - 2*n*x1 + 2*p*q - 2*q*y1 + 2*s1*r1
  c = sq(x1) + sq(m) - 2*m*x1 + sq(p) + sq(y1) - 2*p*y1 - sq(r1)

  d = sq(b) - 4*a*c
  rs = (-b - Math.sqrt(d)) / (2*a)
  xs = m + n*rs
  ys = p + q*rs

  new Circle(xs, ys, rs)


console.log c1 = new Circle(0, 0, 1)
console.log c2 = new Circle(2, 4, 2)
console.log c3 = new Circle(4, 0, 1)

console.log apollonius(c1, c2, c3)
console.log apollonius(c1, c2, c3, -1, -1, -1)
