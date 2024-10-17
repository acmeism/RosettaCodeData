// version 1.1.2

import java.awt.*
import java.awt.geom.Path2D
import javax.swing.*

class Pentagram : JPanel() {
    init {
        preferredSize = Dimension(640, 640)
        background = Color.white
    }

    private fun drawPentagram(g: Graphics2D, len: Int, x: Int, y: Int,
                              fill: Color, stroke: Color) {
        var x2 = x.toDouble()
        var y2 = y.toDouble()
        var angle = 0.0
        val p = Path2D.Float()
        p.moveTo(x2, y2)

        for (i in 0..4) {
            x2 += Math.cos(angle) * len
            y2 += Math.sin(-angle) * len
            p.lineTo(x2, y2)
            angle -= Math.toRadians(144.0)
        }

        p.closePath()
        with(g) {
            color = fill
            fill(p)
            color = stroke
            draw(p)
        }
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                           RenderingHints.VALUE_ANTIALIAS_ON)
        g.stroke = BasicStroke(5.0f, BasicStroke.CAP_ROUND, 0)
        drawPentagram(g, 500, 70, 250, Color(0x6495ED), Color.darkGray)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with(f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Pentagram"
            isResizable = false
            add(Pentagram(), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
