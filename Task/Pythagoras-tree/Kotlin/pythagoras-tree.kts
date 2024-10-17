// version 1.1.2

import java.awt.*
import java.awt.geom.Path2D
import javax.swing.*

class PythagorasTree : JPanel() {
    val depthLimit = 7
    val hue = 0.15f

    init {
        preferredSize = Dimension(640, 640)
        background = Color.white
    }

    private fun drawTree(g: Graphics2D, x1: Float, y1: Float,
                                        x2: Float, y2: Float, depth: Int) {
        if (depth == depthLimit) return

        val dx = x2 - x1
        val dy = y1 - y2

        val x3 = x2 - dy
        val y3 = y2 - dx
        val x4 = x1 - dy
        val y4 = y1 - dx
        val x5 = x4 + 0.5f * (dx - dy)
        val y5 = y4 - 0.5f * (dx + dy)

        val square = Path2D.Float()
        with (square) {
            moveTo(x1, y1)
            lineTo(x2, y2)
            lineTo(x3, y3)
            lineTo(x4, y4)
            closePath()
        }

        g.color = Color.getHSBColor(hue + depth * 0.02f, 1.0f, 1.0f)
        g.fill(square)
        g.color = Color.lightGray
        g.draw(square)

        val triangle = Path2D.Float()
        with (triangle) {
            moveTo(x3, y3)
            lineTo(x4, y4)
            lineTo(x5, y5)
            closePath()
        }

        g.color = Color.getHSBColor(hue + depth * 0.035f, 1.0f, 1.0f)
        g.fill(triangle)
        g.color = Color.lightGray
        g.draw(triangle)

        drawTree(g, x4, y4, x5, y5, depth + 1)
        drawTree(g, x5, y5, x3, y3, depth + 1)
    }

    override fun paintComponent(g: Graphics) {
        super.paintComponent(g)
        drawTree(g as Graphics2D, 275.0f, 500.0f, 375.0f, 500.0f, 0)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with (f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Pythagoras Tree"
            isResizable = false
            add(PythagorasTree(), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null);
            setVisible(true)
        }
    }
}
