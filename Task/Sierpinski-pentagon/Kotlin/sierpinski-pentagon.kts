// version 1.1.2

import java.awt.*
import java.awt.geom.Path2D
import java.util.Random
import javax.swing.*

class SierpinskiPentagon : JPanel() {
    // exterior angle
    private val degrees072 = Math.toRadians(72.0)

    /* After scaling we'll have 2 sides plus a gap occupying the length
       of a side before scaling. The gap is the base of an isosceles triangle
       with a base angle of 72 degrees. */
    private val scaleFactor = 1.0 / (2.0 + Math.cos(degrees072) * 2.0)

    private val margin = 20
    private var limit = 0
    private val r = Random()

    init {
        preferredSize = Dimension(640, 640)
        background = Color.white
        Timer(3000) {
            limit++
            if (limit >= 5) limit = 0
            repaint()
        }.start()
    }

    private fun drawPentagon(g: Graphics2D, x: Double, y: Double, s: Double, depth: Int) {
        var angle = 3.0 * degrees072  // starting angle
        var xx = x
        var yy = y
        var side = s
        if (depth == 0) {
            val p = Path2D.Double()
            p.moveTo(xx, yy)

            // draw from the top
            for (i in 0 until 5) {
                xx += Math.cos(angle) * side
                yy -= Math.sin(angle) * side
                p.lineTo(xx, yy)
                angle += degrees072
            }

            g.color = RandomHue.next()
            g.fill(p)
        }
        else {
            side *= scaleFactor
            /* Starting at the top of the highest pentagon, calculate
               the top vertices of the other pentagons by taking the
               length of the scaled side plus the length of the gap. */
            val distance = side + side * Math.cos(degrees072) * 2.0

            /* The top positions form a virtual pentagon of their own,
               so simply move from one to the other by changing direction. */
            for (i in 0 until 5) {
                xx += Math.cos(angle) * distance
                yy -= Math.sin(angle) * distance
                drawPentagon(g, xx, yy, side, depth - 1)
                angle += degrees072
            }
        }
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        val hw = width / 2
        val radius = hw - 2.0 * margin
        val side = radius * Math.sin(Math.PI / 5.0) * 2.0
        drawPentagon(g, hw.toDouble(), 3.0 * margin, side, limit)
    }

    private class RandomHue {
        /* Try to avoid random color values clumping together */
        companion object {
            val goldenRatioConjugate = (Math.sqrt(5.0) - 1.0) / 2.0
            var hue = Math.random()

            fun next(): Color {
                hue = (hue + goldenRatioConjugate) % 1
                return Color.getHSBColor(hue.toFloat(), 1.0f, 1.0f)
            }
        }
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "Sierpinski Pentagon"
        f.isResizable = true
        f.add(SierpinskiPentagon(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.isVisible = true
    }
}
