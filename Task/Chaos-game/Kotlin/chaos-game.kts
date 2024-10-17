//Version 1.1.51

import java.awt.*
import java.util.Stack
import java.util.Random
import javax.swing.JPanel
import javax.swing.JFrame
import javax.swing.Timer
import javax.swing.SwingUtilities

class ChaosGame : JPanel() {

    class ColoredPoint(x: Int, y: Int, val colorIndex: Int) : Point(x, y)

    val stack = Stack<ColoredPoint>()
    val points: List<Point>
    val colors = listOf(Color.red, Color.green, Color.blue)
    val r = Random()

    init {
        val dim = Dimension(640, 640)
        preferredSize = dim
        background = Color.white
        val margin = 60
        val size = dim.width - 2 * margin
        points = listOf(
            Point(dim.width / 2, margin),
            Point(margin, size),
            Point(margin + size, size)
        )
        stack.push(ColoredPoint(-1, -1, 0))

        Timer(10) {
            if (stack.size < 50_000) {
                for (i in 0 until 1000) addPoint()
                repaint()
            }
        }.start()
    }

    private fun addPoint() {
        val colorIndex = r.nextInt(3)
        val p1 = stack.peek()
        val p2 = points[colorIndex]
        stack.add(halfwayPoint(p1, p2, colorIndex))
    }

    fun drawPoints(g: Graphics2D) {
        for (cp in stack) {
            g.color = colors[cp.colorIndex]
            g.fillOval(cp.x, cp.y, 1, 1)
        }
    }

    fun halfwayPoint(a: Point, b: Point, idx: Int) =
        ColoredPoint((a.x + b.x) / 2, (a.y + b.y) / 2, idx)

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                            RenderingHints.VALUE_ANTIALIAS_ON)
        drawPoints(g)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with (f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Chaos Game"
            isResizable = false
            add(ChaosGame(), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
