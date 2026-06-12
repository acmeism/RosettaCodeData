import math

type
  Vector = tuple[x, y, z: float]
  Matrix = array[3, Vector]

func norm(v: Vector): float =
  sqrt(v.x * v.x + v.y * v.y + v.z * v.z)

func normalized(v: Vector): Vector =
  let length = v.norm()
  result = (v.x / length, v.y / length, v.z / length)

func scalarProduct(v1, v2: Vector): float =
  v1.x * v2.x + v1.y * v2.y + v1.z * v2.z

func vectorProduct(v1, v2: Vector): Vector =
  (v1.y * v2.z - v1.z * v2.y, v1.z * v2.x - v1.x * v2.z, v1.x * v2.y - v1.y * v2.x)

func angle(v1, v2: Vector): float =
  arccos(scalarProduct(v1, v2) / (norm(v1) * norm(v2)))

func `*`(m: Matrix; v: Vector): Vector =
  (scalarProduct(m[0], v), scalarProduct(m[1], v), scalarProduct(m[2], v))

func rotate(p, v: Vector; a: float): Vector =
  let ca = cos(a)
  let sa = sin(a)
  let t = 1 - ca
  let r = [(ca + v.x * v.x * t, v.x * v.y * t - v.z * sa, v.x * v.z * t + v.y * sa),
           (v.x * v.y * t + v.z * sa, ca + v.y * v.y * t, v.y * v.z * t - v.x * sa),
           (v.z * v.x * t - v.y * sa, v.z * v.y * t + v.x * sa, ca + v.z * v.z * t)]
  result = r * p

let
  v1 = (5.0, -6.0, 4.0)
  v2 = (8.0, 5.0, -30.0)
  a = angle(v1, v2)
  vp = vectorProduct(v1, v2)
  nvp = normalized(vp)
  np = v1.rotate(nvp, a)
echo np
