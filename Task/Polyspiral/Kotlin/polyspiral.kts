// version 1.1.0

import java.awt.*
import java.awt.event.ActionEvent
import javax.swing.*

class PolySpiral() : JPanel() {
    private var inc = 0.0

    init {
        preferredSize = Dimension(640, 640)
        background = Color.white
        Timer(40) {
            inc = (inc + 0.05) % 360.0
            repaint()
        }.start()
    }

    private fun drawSpiral(g: Graphics2D, length: Int, angleIncrement: Double) {
        var x1 = width / 2.0
        var y1 = height / 2.0
        var len = length
        var angle = angleIncrement
        for (i in 0 until 150) {
            g.setColor(Color.getHSBColor(i / 150f, 1.0f, 1.0f))
            val x2 = x1 + Math.cos(angle) * len
            val y2 = y1 - Math.sin(angle) * len
            g.drawLine(x1.toInt(), y1.toInt(), x2.toInt(), y2.toInt())
            x1 = x2
            y1 = y2
            len += 3
            angle = (angle + angleIncrement) % (Math.PI * 2.0)
        }
    }

    override protected fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        drawSpiral(g, 5, Math.toRadians(inc))
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "PolySpiral"
        f.setResizable(true)
        f.add(PolySpiral(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.setVisible(true)
    }
}
