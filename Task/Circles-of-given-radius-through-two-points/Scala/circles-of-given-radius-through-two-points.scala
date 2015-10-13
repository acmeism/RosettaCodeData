import org.scalatest.FunSuite
import math._

case class V2(x: Double, y: Double) {
  val distance = hypot(x, y)
  def /(other: V2) = V2((x+other.x) / 2.0, (y+other.y) / 2.0)
  def -(other: V2) = V2(x-other.x,y-other.y)
  override def equals(other: Any) = other match {
    case p: V2 => abs(x-p.x) <  0.0001 && abs(y-p.y) <  0.0001
    case _ => false
  }
  override def toString = f"($x%.4f, $y%.4f)"
}

case class Circle(center: V2, radius: Double)

class PointTest extends FunSuite {
  println("       p1               p2         r    result")
  Seq(
    (V2(0.1234, 0.9876), V2(0.8765, 0.2345), 2.0, Seq(Circle(V2(1.8631, 1.9742), 2.0), Circle(V2(-0.8632, -0.7521), 2.0))),
    (V2(0.0000, 2.0000), V2(0.0000, 0.0000), 1.0, Seq(Circle(V2(0.0, 1.0), 1.0))),
    (V2(0.1234, 0.9876), V2(0.1234, 0.9876), 2.0, "coincident points yields infinite circles"),
    (V2(0.1234, 0.9876), V2(0.8765, 0.2345), 0.5, "radius is less then the distance between points"),
    (V2(0.1234, 0.9876), V2(0.1234, 0.9876), 0.0, "radius of zero yields no circles")
  ) foreach { v =>
    print(s"${v._1} ${v._2}  ${v._3}: ")
    circles(v._1, v._2, v._3) match {
      case Right(list) => println(list mkString ",")
        assert(list === v._4)
      case Left(error) => println(error)
        assert(error === v._4)
    }
  }

  def circles(p1: V2, p2: V2, radius: Double) = if (radius == 0.0) {
      Left("radius of zero yields no circles")
    } else if (p1 == p2) {
      Left("coincident points yields infinite circles")
    } else if (radius * 2 < (p1-p2).distance) {
      Left("radius is less then the distance between points")
    } else {
      Right(circlesThruPoints(p1, p2, radius))
    } ensuring { result =>
      result.isLeft || result.right.get.nonEmpty
    }

  def circlesThruPoints(p1: V2, p2: V2, radius: Double): Seq[Circle] = {
    val diff = p2 - p1
    val d = pow(pow(radius, 2) - pow(diff.distance / 2, 2), 0.5)
    val mid = p1 / p2
    Seq(
      Circle(V2(mid.x - d * diff.y / diff.distance, mid.y + d * diff.x / diff.distance), abs(radius)),
      Circle(V2(mid.x + d * diff.y / diff.distance, mid.y - d * diff.x / diff.distance), abs(radius))).distinct
  }
}
