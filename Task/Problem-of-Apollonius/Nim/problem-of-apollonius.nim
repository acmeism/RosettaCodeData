import math

type Circle = tuple[x, y, r: float]

proc solveApollonius(c1, c2, c3: Circle; s1, s2, s3: float): Circle =
  let
    v11 = 2*c2.x - 2*c1.x
    v12 = 2*c2.y - 2*c1.y
    v13 = c1.x*c1.x - c2.x*c2.x + c1.y*c1.y - c2.y*c2.y - c1.r*c1.r + c2.r*c2.r
    v14 = 2*s2*c2.r - 2*s1*c1.r

    v21 = 2*c3.x - 2*c2.x
    v22 = 2*c3.y - 2*c2.y
    v23 = c2.x*c2.x - c3.x*c3.x + c2.y*c2.y - c3.y*c3.y - c2.r*c2.r + c3.r*c3.r
    v24 = 2*s3*c3.r - 2*s2*c2.r

    w12 = v12/v11
    w13 = v13/v11
    w14 = v14/v11

    w22 = v22/v21-w12
    w23 = v23/v21-w13
    w24 = v24/v21-w14

    p = -w23/w22
    q = w24/w22
    m = -w12*p-w13
    n = w14 - w12*q

    a = n*n + q*q - 1
    b = 2*m*n - 2*n*c1.x + 2*p*q - 2*q*c1.y + 2*s1*c1.r
    c = c1.x*c1.x + m*m - 2*m*c1.x + p*p + c1.y*c1.y - 2*p*c1.y - c1.r*c1.r

    d = b*b-4*a*c
    rs = (-b-sqrt(d))/(2*a)

    xs = m+n*rs
    ys = p+q*rs

  return (xs, ys, rs)

let
  c1: Circle = (0.0, 0.0, 1.0)
  c2: Circle = (4.0, 0.0, 1.0)
  c3: Circle = (2.0, 4.0, 2.0)

echo solveApollonius(c1, c2, c3, 1.0, 1.0, 1.0)
echo solveApollonius(c1, c2, c3, -1.0, -1.0, -1.0)
