package scala.ray_casting

case class Edge(_1: (Double, Double), _2: (Double, Double)) {
  import Math._
  import Double._

  def raySegI(p: (Double, Double)): Boolean = {
    if (_1._2 > _2._2) return Edge(_2, _1).raySegI(p)
    if (p._2 == _1._2 || p._2 == _2._2) return raySegI((p._1, p._2 + epsilon))
    if (p._2 > _2._2 || p._2 < _1._2 || p._1 > max(_1._1, _2._1))
      return false
    if (p._1 < min(_1._1, _2._1)) return true
    val blue = if (abs(_1._1 - p._1) > MinValue) (p._2 - _1._2) / (p._1 - _1._1) else MaxValue
    val red = if (abs(_1._1 - _2._1) > MinValue) (_2._2 - _1._2) / (_2._1 - _1._1) else MaxValue
    blue >= red
  }

  final val epsilon = 0.00001
}

case class Figure(name: String, edges: Seq[Edge]) {
  def contains(p: (Double, Double)) = edges.count(_.raySegI(p)) % 2 != 0
}

object Ray_casting extends App {
  val figures = Seq(Figure("Square", Seq(((0.0, 0.0), (10.0, 0.0)), ((10.0, 0.0), (10.0, 10.0)),
    ((10.0, 10.0), (0.0, 10.0)),((0.0, 10.0), (0.0, 0.0)))),
    Figure("Square hole", Seq(((0.0, 0.0), (10.0, 0.0)), ((10.0, 0.0), (10.0, 10.0)),
      ((10.0, 10.0), (0.0, 10.0)), ((0.0, 10.0), (0.0, 0.0)), ((2.5, 2.5), (7.5, 2.5)),
      ((7.5, 2.5), (7.5, 7.5)),((7.5, 7.5), (2.5, 7.5)), ((2.5, 7.5), (2.5, 2.5)))),
    Figure("Strange", Seq(((0.0, 0.0), (2.5, 2.5)), ((2.5, 2.5), (0.0, 10.0)),
      ((0.0, 10.0), (2.5, 7.5)), ((2.5, 7.5), (7.5, 7.5)), ((7.5, 7.5), (10.0, 10.0)),
      ((10.0, 10.0), (10.0, 0.0)), ((10.0, 0.0), (2.5, 2.5)))),
    Figure("Exagon", Seq(((3.0, 0.0), (7.0, 0.0)), ((7.0, 0.0), (10.0, 5.0)), ((10.0, 5.0), (7.0, 10.0)),
      ((7.0, 10.0), (3.0, 10.0)), ((3.0, 10.0), (0.0, 5.0)), ((0.0, 5.0), (3.0, 0.0)))))

  val points = Seq((5.0, 5.0), (5.0, 8.0), (-10.0, 5.0), (0.0, 5.0), (10.0, 5.0), (8.0, 5.0), (10.0, 10.0))

  println("points: " + points)
  for (f <- figures) {
    println("figure: " + f.name)
    println("        " + f.edges)
    println("result: " + (points map f.contains))
  }

  private implicit def to_edge(p: ((Double, Double), (Double, Double))): Edge = Edge(p._1, p._2)
}
