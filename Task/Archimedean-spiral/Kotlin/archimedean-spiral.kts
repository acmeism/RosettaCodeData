// version 1.1.0

import java.awt.*
import javax.swing.*

class ArchimedeanSpiral : JPanel() {
    init {
        preferredSize = Dimension(640, 640)
        background = Color.white
    }

    private fun drawGrid(g: Graphics2D) {
        g.color = Color(0xEEEEEE)
        g.stroke = BasicStroke(2f)
        val angle = Math.toRadians(45.0)
        val w = width
        val center = w / 2
        val margin = 10
        val numRings = 8
        val spacing = (w - 2 * margin) / (numRings * 2)

        for (i in 0 until numRings) {
            val pos = margin + i * spacing
            val size = w - (2 * margin + i * 2 * spacing)
            g.drawOval(pos, pos, size, size)
            val ia = i * angle
            val x2 = center + (Math.cos(ia) * (w - 2 * margin) / 2).toInt()
            val y2 = center - (Math.sin(ia) * (w - 2 * margin) / 2).toInt()
            g.drawLine(center, center, x2, y2)
        }
    }

    private fun drawSpiral(g: Graphics2D) {
        g.stroke = BasicStroke(2f)
        g.color = Color.magenta
        val degrees = Math.toRadians(0.1)
        val center = width / 2
        val end = 360 * 2 * 10 * degrees
        val a = 0.0
        val b = 20.0
        val c = 1.0
        var theta = 0.0
        while (theta < end) {
            val r = a + b * Math.pow(theta, 1.0 / c)
            val x = r * Math.cos(theta)
            val y = r * Math.sin(theta)
            plot(g, (center + x).toInt(), (center - y).toInt())
            theta += degrees
        }
    }

    private fun plot(g: Graphics2D, x: Int, y: Int) {
        g.drawOval(x, y, 1, 1)
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        drawGrid(g)
        drawSpiral(g)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "Archimedean Spiral"
        f.isResizable = false
        f.add(ArchimedeanSpiral(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.isVisible = true
    }
}
