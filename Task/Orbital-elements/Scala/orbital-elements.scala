import scala.language.existentials

object OrbitalElements extends App {
  private val ps = orbitalStateVectors(1.0, 0.1, 0.0, 355.0 / (113.0 * 6.0), 0.0, 0.0)
  println(f"Position : ${ps(0)}%s%nSpeed    : ${ps(1)}%s")

  private def orbitalStateVectors(semimajorAxis: Double,
                                  eccentricity: Double,
                                  inclination: Double,
                                  longitudeOfAscendingNode: Double,
                                  argumentOfPeriapsis: Double,
                                  trueAnomaly: Double) = {

    def mulAdd(v1: Vector, x1: Double, v2: Vector, x2: Double) = v1 * x1 + v2 * x2

    case class Vector(x: Double, y: Double, z: Double) {
      def +(term: Vector) =
        Vector(x + term.x, y + term.y, z + term.z)
      def *(factor: Double) = Vector(factor * x, factor * y, factor * z)
      def /(divisor: Double) = Vector(x / divisor, y / divisor, z / divisor)
      def abs: Double = math.sqrt(x * x + y * y + z * z)
      override def toString: String = f"($x%.16f, $y%.16f, $z%.16f)"
    }

    def rotate(i: Vector, j: Vector, alpha: Double) =
      Array[Vector](mulAdd(i, math.cos(alpha), j, math.sin(alpha)),
        mulAdd(i, -math.sin(alpha), j, math.cos(alpha)))

    val p = rotate(Vector(1, 0, 0), Vector(0, 1, 0), longitudeOfAscendingNode)
    val p2 = rotate(p(0),
      rotate(p(1), Vector(0, 0, 1), inclination)(0),
      argumentOfPeriapsis)
    val l = semimajorAxis *
      (if (eccentricity == 1.0) 2.0 else 1.0 - eccentricity * eccentricity)
    val (c, s) = (math.cos(trueAnomaly), math.sin(trueAnomaly))
    val r = l / (1.0 + eccentricity * c)
    val rprime = s * r * r / l
    val speed = mulAdd(p2(0), rprime * c - r * s, p2(1), rprime * s + r * c)
    Array[Vector](mulAdd(p(0), c, p2(1), s) * r,
      speed / speed.abs * math.sqrt(2.0 / r - 1.0 / semimajorAxis))
  }

}
