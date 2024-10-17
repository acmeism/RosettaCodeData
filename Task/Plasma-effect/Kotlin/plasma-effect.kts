// version 1.1.2

import java.awt.*
import java.awt.image.BufferedImage
import javax.swing.*

class PlasmaEffect : JPanel() {
    private val plasma: Array<FloatArray>
    private var hueShift = 0.0f
    private val img: BufferedImage

    init {
        val dim = Dimension(640, 640)
        preferredSize = dim
        background = Color.white
        img = BufferedImage(dim.width, dim.height, BufferedImage.TYPE_INT_RGB)
        plasma = createPlasma(dim.height, dim.width)
        // animate about 24 fps and shift hue value with every frame
        Timer(42) {
            hueShift = (hueShift + 0.02f) % 1
            repaint()
        }.start()
    }

    private fun createPlasma(w: Int, h: Int): Array<FloatArray> {
        val buffer = Array(h) { FloatArray(w) }
        for (y in 0 until h)
            for (x in 0 until w) {
                var value = Math.sin(x / 16.0)
                value += Math.sin(y / 8.0)
                value += Math.sin((x + y) / 16.0)
                value += Math.sin(Math.sqrt((x * x + y * y).toDouble()) / 8.0)
                value += 4.0  // shift range from -4 .. 4 to 0 .. 8
                value /= 8.0  // bring range down to 0 .. 1
                if (value < 0.0 || value > 1.0) throw RuntimeException("Hue value out of bounds")
                buffer[y][x] = value.toFloat()
            }
        return buffer
    }

    private fun drawPlasma(g: Graphics2D) {
        val h = plasma.size
        val w = plasma[0].size
        for (y in 0 until h)
            for (x in 0 until w) {
                val hue = hueShift + plasma[y][x] % 1
                img.setRGB(x, y, Color.HSBtoRGB(hue, 1.0f, 1.0f))
            }
        g.drawImage(img, 0, 0, null)
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        drawPlasma(g);
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "Plasma Effect"
        f.isResizable = false
        f.add(PlasmaEffect(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.isVisible = true
    }
}
