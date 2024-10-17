// version 1.1

import java.awt.*
import java.time.LocalTime
import javax.swing.*

class Clock : JPanel() {
    private val degrees06: Float = (Math.PI / 30.0).toFloat()
    private val degrees30: Float = degrees06 * 5.0f
    private val degrees90: Float =  degrees30 * 3.0f
    private val size = 590
    private val spacing = 40
    private val diameter = size - 2 * spacing
    private val cx = diameter / 2 + spacing
    private val cy = cx

    init {
        preferredSize = Dimension(size, size)
        background =  Color.white
        Timer(1000) {
            repaint()
        }.start()
    }

    override public fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        drawFace(g)
        val time  = LocalTime.now()
        val hour = time.hour
        val minute = time.minute
        val second = time.second
        var angle: Float = degrees90 - degrees06 * second
        drawHand(g, angle, diameter / 2 - 30, Color.red)
        val minsecs: Float = minute + second / 60.0f
        angle = degrees90 - degrees06 * minsecs
        drawHand(g, angle, diameter / 3 + 10, Color.black)
        val hourmins: Float = hour + minsecs / 60.0f
        angle = degrees90 - degrees30 * hourmins
        drawHand(g, angle, diameter / 4 + 10, Color.black)
    }

    private fun drawFace(g: Graphics2D) {
        g.stroke = BasicStroke(2.0f)
        g.color = Color.yellow
        g.fillOval(spacing, spacing, diameter, diameter)
        g.color = Color.black
        g.drawOval(spacing, spacing, diameter, diameter)
    }

    private fun drawHand(g: Graphics2D, angle: Float, radius: Int, color: Color) {
        val x: Int  = cx + (radius.toDouble() * Math.cos(angle.toDouble())).toInt()
        val y: Int =  cy - (radius.toDouble() * Math.sin(angle.toDouble())).toInt()
        g.color = color
        g.drawLine(cx, cy, x, y)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "Clock"
        f.isResizable = false
        f.add(Clock(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.isVisible = true
    }
}
