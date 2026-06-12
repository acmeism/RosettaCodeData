import math, strformat

type Vector = tuple[x, y, z: float]

func `+`(v1, v2: Vector): Vector = (v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
func `*`(v: Vector; m: float): Vector = (v.x * m, v.y * m, v.z * m)
func `*=`(v: var Vector; m: float) = v.x *= m; v.y *= m; v.z *= m
func `/=`(v: var Vector; d: float) = v.x /= d; v.y /= d; v.z /= d
func abs(v: Vector): float = sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
func `$`(v: Vector): string = &"({v.x}, {v.y}, {v.z})"

func orbitalStateVectors(semimajorAxis: float,
                         eccentricity: float,
                         inclination: float,
                         longitudeOfAscendingNode: float,
                         argumentOfPeriapsis: float,
                         trueAnomaly: float): tuple[position, speed: Vector] =

  var
    i: Vector = (1.0, 0.0, 0.0)
    j: Vector = (0.0, 1.0, 0.0)
    k: Vector = (0.0, 0.0, 1.0)


  func mulAdd(v1: Vector; x1: float; v2: Vector; x2: float): Vector = v1 * x1 + v2 * x2

  func rotate(a, b: Vector; alpha: float): (Vector, Vector) =
    (mulAdd(a, cos(alpha), b, sin(alpha)), mulAdd(a, -sin(alpha), b, cos(alpha)))

  var p = rotate(i, j, longitudeOfAscendingNode)
  (i, j) = p
  p = rotate(j, k, inclination)
  j = p[0]
  p = rotate(i, j, argumentOfPeriapsis)
  (i, j) = p

  let
    l = semimajorAxis * (if eccentricity == 1: 2.0 else: 1.0 - eccentricity * eccentricity)
    c = cos(trueAnomaly)
    s = sin(trueAnomaly)
    r = l / (1.0 + eccentricity * c)
    rprime = s * r * r / l

  result.position = mulAdd(i, c, j, s) * r
  result.speed = mulAdd(i, rprime * c - r * s, j, rprime * s + r * c)
  result.speed /= abs(result.speed)
  result.speed *= sqrt(2 / r - 1 / semimajorAxis)


let (position, speed) = orbitalStateVectors(semimajorAxis = 1.0,
                                            eccentricity = 0.1,
                                            inclination = 0.0,
                                            longitudeOfAscendingNode = 355.0 / (113.0 * 6.0),
                                            argumentOfPeriapsis = 0.0,
                                            trueAnomaly = 0.0)
echo "Position: ", position
echo "Speed:    ", speed
