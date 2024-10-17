// version 1.1.2

import java.awt.*
import javax.swing.*

class XiaolinWu: JPanel() {
    init {
        preferredSize = Dimension(640, 640)
        background = Color.white
    }

    private fun plot(g: Graphics2D, x: Double, y: Double, c: Double) {
        g.color = Color(0f, 0f, 0f, c.toFloat())
        g.fillOval(x.toInt(), y.toInt(), 2, 2)
    }

    private fun ipart(x: Double) = x.toInt()

    private fun fpart(x: Double) = x - Math.floor(x)

    private fun rfpart(x: Double) = 1.0 - fpart(x)

    private fun drawLine(g: Graphics2D, x0: Double, y0: Double, x1: Double, y1: Double) {
        val steep = Math.abs(y1 - y0) > Math.abs(x1 - x0)
        if (steep) drawLine(g, y0, x0, y1, x1)
        if (x0 > x1) drawLine(g, x1, y1, x0, y0)

        val dx = x1 - x0
        val dy = y1 - y0
        val gradient = dy / dx

        // handle first endpoint
        var xend = Math.round(x0).toDouble()
        var yend = y0 + gradient * (xend - x0)
        var xgap = rfpart(x0 + 0.5)
        val xpxl1 = xend  // this will be used in the main loop
        val ypxl1 = ipart(yend).toDouble()

        if (steep) {
            plot(g, ypxl1, xpxl1, rfpart(yend) * xgap)
            plot(g, ypxl1 + 1.0, xpxl1, fpart(yend) * xgap)
        }
        else {
            plot(g, xpxl1, ypxl1, rfpart(yend) * xgap)
            plot(g, xpxl1, ypxl1 + 1.0, fpart(yend) * xgap)
        }

        // first y-intersection for the main loop
        var intery = yend + gradient

        // handle second endpoint
        xend = Math.round(x1).toDouble()
        yend = y1 + gradient * (xend - x1)
        xgap = fpart(x1 + 0.5)
        val xpxl2 = xend  // this will be used in the main loop
        val ypxl2 = ipart(yend).toDouble()

        if (steep) {
            plot(g, ypxl2, xpxl2, rfpart(yend) * xgap)
            plot(g, ypxl2 + 1.0, xpxl2, fpart(yend) * xgap)
        }
        else {
            plot(g, xpxl2, ypxl2, rfpart(yend) * xgap)
            plot(g, xpxl2, ypxl2 + 1.0, fpart(yend) * xgap)
        }

        // main loop
        var x = xpxl1 + 1.0
        while (x <=  xpxl2 - 1) {
            if (steep) {
                plot(g, ipart(intery).toDouble(), x, rfpart(intery))
                plot(g, ipart(intery).toDouble() + 1.0, x, fpart(intery))
            }
            else {
                plot(g, x, ipart(intery).toDouble(), rfpart(intery))
                plot(g, x, ipart(intery).toDouble() + 1.0, fpart(intery))
            }
            intery += gradient
            x++
        }
    }

    override protected fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        drawLine(g, 550.0, 170.0, 50.0, 435.0)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "Xiaolin Wu's line algorithm"
        f.isResizable = false
        f.add(XiaolinWu(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.isVisible = true
    }
}
