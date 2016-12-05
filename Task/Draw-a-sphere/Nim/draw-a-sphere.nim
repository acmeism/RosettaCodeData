import math

type Point = tuple[x,y,z: float]

const shades = ".:!*oe&#%@"

proc normalize(x, y, z: float): Point =
  let len = sqrt(x*x + y*y + z*z)
  (x / len, y / len, z / len)

proc dot(a, b: Point): float =
  result = max(0, - a.x*b.x - a.y*b.y - a.z*b.z)

let light = normalize(30.0, 30.0, -50.0)

proc drawSphere(r, k, ambient) =
  for i in -r .. r:
    let x = i.float + 0.5
    for j in -2*r .. 2*r:
      let y = j.float / 2.0 + 0.5
      if x*x + y*y <= float r*r:
        let
          v = normalize(x, y, sqrt(float(r*r) - x*x - y*y))
          b = pow(dot(light, v), k) + ambient
          i = clamp(int((1.0 - b) * shades.high.float), 0, shades.high)
        stdout.write shades[i]
      else: stdout.write ' '
    stdout.write "\n"

drawSphere 20, 4.0, 0.1
drawSphere 10, 2.0, 0.4
