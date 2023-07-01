type Vector = tuple[x, y, z: float]


func `+`(v1, v2: Vector): Vector =
  ## Add two vectors.
  (v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)

func `-`(v1, v2: Vector): Vector =
  ## Subtract a vector to another one.
  (v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)

func `*`(v1, v2: Vector): float =
  ## Compute the dot product of two vectors.
  v1.x * v2.x + v1.y * v2.y + v1.z * v2.z

func `*`(v: Vector; k: float): Vector =
  ## Multiply a vector by a scalar.
  (v.x * k, v.y * k, v.z * k)


func intersection(lineVector, linePoint, planeVector, planePoint: Vector): Vector =
  ## Return the coordinates of the intersection of two vectors.

  let tnum = planeVector * (planePoint - linePoint)
  let tdenom = planeVector * lineVector
  if tdenom == 0: return (Inf, Inf, Inf)  # No intersection.
  let t = tnum / tdenom
  result = lineVector * t + linePoint

let coords = intersection(lineVector = (0.0, -1.0, -1.0),
                          linePoint = (0.0, 0.0, 10.0),
                          planeVector = (0.0, 0.0, 1.0),
                          planePoint = (0.0, 0.0, 5.0))
echo "Intersection at ", coords
