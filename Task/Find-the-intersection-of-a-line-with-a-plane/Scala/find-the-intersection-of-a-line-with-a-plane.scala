object LinePLaneIntersection extends App {
  val (rv, rp, pn, pp) =
    (Vector3D(0.0, -1.0, -1.0), Vector3D(0.0, 0.0, 10.0), Vector3D(0.0, 0.0, 1.0), Vector3D(0.0, 0.0, 5.0))
  val ip = intersectPoint(rv, rp, pn, pp)

  def intersectPoint(rayVector: Vector3D,
                     rayPoint: Vector3D,
                     planeNormal: Vector3D,
                     planePoint: Vector3D): Vector3D = {
    val diff = rayPoint - planePoint
    val prod1 = diff dot planeNormal
    val prod2 = rayVector dot planeNormal
    val prod3 = prod1 / prod2
    rayPoint - rayVector * prod3
  }

  case class Vector3D(x: Double, y: Double, z: Double) {
    def +(v: Vector3D) = Vector3D(x + v.x, y + v.y, z + v.z)
    def -(v: Vector3D) = Vector3D(x - v.x, y - v.y, z - v.z)
    def *(s: Double) = Vector3D(s * x, s * y, s * z)
    def dot(v: Vector3D): Double = x * v.x + y * v.y + z * v.z
    override def toString = s"($x, $y, $z)"
  }

  println(s"The ray intersects the plane at $ip")
}
