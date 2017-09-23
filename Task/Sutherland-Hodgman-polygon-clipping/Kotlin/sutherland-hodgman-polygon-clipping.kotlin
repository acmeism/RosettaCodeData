// version 1.1.2

import java.awt.*
import java.awt.geom.Line2D
import javax.swing.*

class SutherlandHodgman : JPanel() {
    private val subject = listOf(
        doubleArrayOf( 50.0, 150.0), doubleArrayOf(200.0,  50.0), doubleArrayOf(350.0, 150.0),
        doubleArrayOf(350.0, 300.0), doubleArrayOf(250.0, 300.0), doubleArrayOf(200.0, 250.0),
        doubleArrayOf(150.0, 350.0), doubleArrayOf(100.0, 250.0), doubleArrayOf(100.0, 200.0)
    )

    private val clipper = listOf(
        doubleArrayOf(100.0, 100.0), doubleArrayOf(300.0, 100.0),
        doubleArrayOf(300.0, 300.0), doubleArrayOf(100.0, 300.0)
    )

    private var result = subject.toMutableList()

    init {
        preferredSize = Dimension(600, 500)
        clipPolygon()
    }

    private fun clipPolygon() {
        val len = clipper.size
        for (i in 0 until len) {
            val len2 = result.size
            val input = result
            result = mutableListOf<DoubleArray>()
            val a = clipper[(i + len - 1) % len]
            val b = clipper[i]

            for (j in 0 until len2) {
                val p = input[(j + len2 - 1) % len2]
                val q = input[j]

                if (isInside(a, b, q)) {
                    if (!isInside(a, b, p)) result.add(intersection(a, b, p, q))
                    result.add(q)
                }
                else if (isInside(a, b, p)) result.add(intersection(a, b, p, q))
            }
        }
    }

    private fun isInside(a: DoubleArray, b: DoubleArray, c: DoubleArray) =
        (a[0] - c[0]) * (b[1] - c[1]) > (a[1] - c[1]) * (b[0] - c[0])

    private fun intersection(a: DoubleArray, b: DoubleArray,
                             p: DoubleArray, q: DoubleArray): DoubleArray {
        val a1 = b[1] - a[1]
        val b1 = a[0] - b[0]
        val c1 = a1 * a[0] + b1 * a[1]

        val a2 = q[1] - p[1]
        val b2 = p[0] - q[0]
        val c2 = a2 * p[0] + b2 * p[1]

        val d = a1 * b2 - a2 * b1
        val x = (b2 * c1 - b1 * c2) / d
        val y = (a1 * c2 - a2 * c1) / d

        return doubleArrayOf(x, y)
    }

    override fun paintComponent(g: Graphics) {
        super.paintComponent(g)
        val g2 = g as Graphics2D
        g2.translate(80, 60)
        g2.stroke = BasicStroke(3.0f)
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                            RenderingHints.VALUE_ANTIALIAS_ON)
        drawPolygon(g2, subject, Color.blue)
        drawPolygon(g2, clipper, Color.red)
        drawPolygon(g2, result, Color.green)
    }

    private fun drawPolygon(g2: Graphics2D, points: List<DoubleArray>, color: Color) {
        g2.color = color
        val len = points.size
        val line = Line2D.Double()
        for (i in 0 until len) {
            val p1 = points[i]
            val p2 = points[(i + 1) % len]
            line.setLine(p1[0], p1[1], p2[0], p2[1])
            g2.draw(line)
        }
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with(f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            add(SutherlandHodgman(), BorderLayout.CENTER)
            title = "Sutherland-Hodgman"
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
