type point = { x:float; y:float }
type circle = { center: point; radius: float; }

let new_circle x y r =
   { center = { x=x; y=y }; radius = r }

let print_circle c =
   printfn "Circle(x=%.2f, y=%.2f, r=%.2f)"
     c.center.x c.center.y c.radius

let xyr c = c.center.x, c.center.y, c.radius

let solve_apollonius c1 c2 c3
                     s1 s2 s3 =

   let x1, y1, r1 = xyr c1
   let x2, y2, r2 = xyr c2
   let x3, y3, r3 = xyr c3

   let v11 = 2. * x2 - 2. * x1
   let v12 = 2. * y2 - 2. * y1
   let v13 = x1*x1 - x2*x2 + y1*y1 - y2*y2 - r1*r1 + r2*r2
   let v14 = (2. * s2 * r2) - (2. * s1 * r1)

   let v21 = 2. * x3 - 2. * x2
   let v22 = 2. * y3 - 2. * y2
   let v23 = x2*x2 - x3*x3 + y2*y2 - y3*y3 - r2*r2 + r3*r3
   let v24 = (2. * s3 * r3) - (2. * s2 * r2)

   let w12 = v12 / v11
   let w13 = v13 / v11
   let w14 = v14 / v11

   let w22 = v22 / v21 - w12
   let w23 = v23 / v21 - w13
   let w24 = v24 / v21 - w14

   let p = - w23 / w22
   let q = w24 / w22
   let m = - w12 * p - w13
   let n = w14 - w12 * q

   let a = n*n + q*q - 1.
   let b = 2.*m*n - 2.*n*x1 + 2.*p*q - 2.*q*y1 + 2.*s1*r1
   let c = x1*x1 + m*m - 2.*m*x1 + p*p + y1*y1 - 2.*p*y1 - r1*r1

   let d = b * b - 4. * a * c
   let rs = (- b - (sqrt d)) / (2. * a)

   let xs = m + n * rs
   let ys = p + q * rs

   new_circle xs ys rs


[<EntryPoint>]
let main argv =
  let c1 = new_circle 0. 0. 1.
  let c2 = new_circle 4. 0. 1.
  let c3 = new_circle 2. 4. 2.

  let r1 = solve_apollonius c1 c2 c3 1. 1. 1.
  print_circle r1

  let r2 = solve_apollonius c1 c2 c3 (-1.) (-1.) (-1.)
  print_circle r2
  0
