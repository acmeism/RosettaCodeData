import javax.swing.{ JFrame, JPanel }

object SutherlandHodgman extends JFrame with App {
    import java.awt.BorderLayout

    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
    setVisible(true)
    val content = getContentPane()
    content.setLayout(new BorderLayout())
    content.add(SutherlandHodgmanPanel, BorderLayout.CENTER)
    setTitle("SutherlandHodgman")
    pack()
    setLocationRelativeTo(null)
}

object SutherlandHodgmanPanel extends JPanel {
    import java.awt.{ Color, Graphics, Graphics2D }

    setPreferredSize(new java.awt.Dimension(600, 500))

    // subject and clip points are assumed to be valid
    val subject = Seq((50D, 150D), (200D, 50D), (350D, 150D), (350D, 300D), (250D, 300D), (200D, 250D), (150D, 350D), (100D, 250D), (100D, 200D))
    val clipper = Seq((100D, 100D), (300D, 100D), (300D, 300D), (100D, 300D))
    var result = subject

    val len = clipper.size
    for (i <- 0 until len) {
        val len2 = result.size
        val input = result
        result = Seq()

        val A = clipper((i + len - 1) % len)
        val B = clipper(i)

        for (j <- 0 until len2) {
            val P = input((j + len2 - 1) % len2)
            val Q = input(j)

            if (inside(A, B, Q)) {
                if (!inside(A, B, P))
                    result = result :+ intersection(A, B, P, Q)
                result = result :+ Q
            }
            else if (inside(A, B, P))
                result = result :+ intersection(A, B, P, Q)
        }
    }

    override def paintComponent(g: Graphics) {
        import java.awt.RenderingHints._

        super.paintComponent(g)
        val g2 = g.asInstanceOf[Graphics2D]
        g2.translate(80, 60)
        g2.setStroke(new java.awt.BasicStroke(3))
        g2.setRenderingHint(KEY_ANTIALIASING, VALUE_ANTIALIAS_ON)
        g2.draw_polygon(subject, Color.blue)
        g2.draw_polygon(clipper, Color.red)
        g2.draw_polygon(result, Color.green)
    }

    private def inside(a: (Double, Double), b: (Double, Double), c: (Double, Double)) =
        (a._1 - c._1) * (b._2 - c._2) > (a._2 - c._2) * (b._1 - c._1)

    private def intersection(a: (Double, Double), b: (Double, Double), p: (Double, Double), q: (Double, Double)) = {
        val A1 = b._2 - a._2
        val B1 = a._1 - b._1
        val C1 = A1 * a._1 + B1 * a._2
        val A2 = q._2 - p._2
        val B2 = p._1 - q._1
        val C2 = A2 * p._1 + B2 * p._2

        val det = A1 * B2 - A2 * B1
        ((B2 * C1 - B1 * C2) / det, (A1 * C2 - A2 * C1) / det)
    }

    private implicit final class Polygon_drawing(g: Graphics2D) {
        def draw_polygon(points: Seq[(Double, Double)], color: Color) {
            g.setColor(color)
            val len = points.length
            val line = new java.awt.geom.Line2D.Double()
            for (i <- 0 until len) {
                val p1 = points(i)
                val p2 = points((i + 1) % len)
                line.setLine(p1._1, p1._2, p2._1, p2._2)
                g.draw(line)
            }
        }
    }
}
