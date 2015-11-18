case class Figure(name: String, edges: ((Double, Double), (Double, Double))*) {}

object Ray_casting extends App {
    import Math._
    import Double._

    val figures = Array(Figure("Square", ((0.0, 0.0), (10.0, 0.0)),
        ((10.0, 0.0), (10.0, 10.0)), ((10.0, 10.0), (0.0, 10.0)),
        ((0.0, 10.0), (0.0, 0.0))),
        Figure("Square hole", ((0.0, 0.0), (10.0, 0.0)), ((10.0, 0.0), (10.0, 10.0)),
            ((10.0, 10.0), (0.0, 10.0)), ((0.0, 10.0), (0.0, 0.0)),
            ((2.5, 2.5), (7.5, 2.5)), ((7.5, 2.5), (7.5, 7.5)),
            ((7.5, 7.5), (2.5, 7.5)), ((2.5, 7.5), (2.5, 2.5))),
        Figure("Strange", ((0.0, 0.0), (2.5, 2.5)), ((2.5, 2.5), (0.0, 10.0)),
            ((0.0, 10.0), (2.5, 7.5)), ((2.5, 7.5), (7.5, 7.5)),
            ((7.5, 7.5), (10.0, 10.0)), ((10.0, 10.0), (10.0, 0.0)),
            ((10.0, 0), (2.5, 2.5))),
        Figure("Exagon", ((3.0, 0.0), (7.0, 0.0)), ((7.0, 0.0), (10.0, 5.0)),
            ((10.0, 5.0), (7.0, 10.0)), ((7.0, 10.0), (3.0, 10.0)),
            ((3.0, 10.0), (0.0, 5.0)), ((0.0, 5.0), (3.0, 0.0))))

    val points = Array((5.0, 5.0), (5.0, 8.0), (-10.0, 5.0), (0.0, 5.0), (10.0, 5.0), (8.0, 5.0), (10.0, 10.0))

    figures foreach { f =>
        println("Is point inside figure " + f.name + '?')
        points foreach { p => println("  " + p + ": " + contains(f, p)) }
        println
    }

    private def raySegI(p: (Double, Double), e: ((Double, Double), (Double, Double))): Boolean = {
        val epsilon = 0.00001
        if (e._1._2 > e._2._2)
            return raySegI(p, (e._2, e._1))
        if (p._2 == e._1._2 || p._2 == e._2._2)
            return raySegI((p._1, p._2 + epsilon), e)
        if (p._2 > e._2._2 || p._2 < e._1._2 || p._1 > max(e._1._1, e._2._1))
            return false
        if (p._1 < min(e._1._1, e._2._1))
            return true
        val blue = if (abs(e._1._1 - p._1) > MinValue) (p._2 - e._1._2) / (p._1 - e._1._1) else MaxValue
        val red = if (abs(e._1._1 - e._2._1) > MinValue) (e._2._2 - e._1._2) / (e._2._1 - e._1._1) else MaxValue
        blue >= red
    }

    private def contains(f: Figure, p: (Double, Double)) = f.edges.count(raySegI(p, _)) % 2 != 0
}
