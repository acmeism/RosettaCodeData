// version 1.1.0

import java.awt.*
import java.awt.image.BufferedImage
import javax.swing.*

class BarnsleyFern(private val dim: Int) : JPanel() {
    private val img: BufferedImage

    init {
        preferredSize = Dimension(dim, dim)
        background = Color.black
        img = BufferedImage(dim, dim, BufferedImage.TYPE_INT_ARGB)
        createFern(dim, dim)
    }

    private fun createFern(w: Int, h: Int) {
        var x = 0.0
        var y = 0.0
        for (i in 0 until 200_000) {
            var tmpx: Double
            var tmpy: Double
            val r = Math.random()
            if (r <= 0.01) {
                tmpx = 0.0
                tmpy = 0.16 * y
            }
            else if (r <= 0.86) {
                tmpx =  0.85 * x + 0.04 * y
                tmpy = -0.04 * x + 0.85 * y + 1.6
            }
            else if (r <= 0.93) {
                tmpx = 0.2  * x - 0.26 * y
                tmpy = 0.23 * x + 0.22 * y + 1.6
            }
            else {
                tmpx = -0.15 * x + 0.28 * y
                tmpy =  0.26 * x + 0.24 * y + 0.44
            }
            x = tmpx
            y = tmpy
            img.setRGB(Math.round(w / 2.0 + x * w / 11.0).toInt(),
                       Math.round(h - y * h / 11.0).toInt(), 0xFF32CD32.toInt())
        }
    }

    override protected fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        g.drawImage(img, 0, 0, null)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "Barnsley Fern"
        f.setResizable(false)
        f.add(BarnsleyFern(640), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.setVisible(true)
    }
}
