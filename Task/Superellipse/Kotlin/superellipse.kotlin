// version 1.1.2

import java.awt.*
import java.awt.geom.Path2D
import javax.swing.*
import java.lang.Math.pow

/* assumes a == b */
class SuperEllipse(val n: Double, val a: Int) : JPanel() {
    init {
        require(n > 0.0 && a > 0)
        preferredSize = Dimension(650, 650)
        background = Color.black
    }

    private fun drawEllipse(g: Graphics2D) {
        val points = DoubleArray(a + 1)
        val p = Path2D.Double()
        p.moveTo(a.toDouble(), 0.0)

        // calculate first quadrant
        for (x in a downTo 0) {
            points[x] = pow(pow(a.toDouble(), n) - pow(x.toDouble(), n), 1.0 / n)
            p.lineTo(x.toDouble(), -points[x])
        }

        // mirror to others
        for (x in 0..a) p.lineTo(x.toDouble(), points[x])
        for (x in a downTo 0) p.lineTo(-x.toDouble(), points[x])
        for (x in 0..a) p.lineTo(-x.toDouble(), -points[x])

        with(g) {
            translate(width / 2, height / 2)
            color = Color.yellow
            fill(p)
        }
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                           RenderingHints.VALUE_ANTIALIAS_ON)
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,
                           RenderingHints.VALUE_TEXT_ANTIALIAS_ON)
        drawEllipse(g)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with (f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Super Ellipse"
            isResizable = false
            add(SuperEllipse(2.5, 200), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
