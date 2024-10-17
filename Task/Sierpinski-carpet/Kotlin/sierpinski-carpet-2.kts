// version 1.1.2

import java.awt.*
import javax.swing.*

public class SierpinskiCarpet : JPanel() {
    private val dim = 513
    private val margin = 20
    private var limit = dim

    init {
        val size = dim + 2 * margin
        preferredSize = Dimension(size, size)
        background = Color.blue
        foreground = Color.yellow
        Timer(2000) {
            limit /= 3
            if (limit <= 3) limit = dim
            repaint()
        }.start()
    }

    private fun drawCarpet(g: Graphics2D, x: Int, y: Int, s: Int) {
        var size = s
        if (s < limit) return
        size /= 3
        for (i in 0 until 9) {
            if (i == 4) {
                g.fillRect(x + size, y + size, size, size)
            }
            else {
                drawCarpet(g, x + (i % 3) * size, y + (i / 3) * size, size)
            }
        }
    }

    override fun paintComponent(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
        g.translate(margin, margin)
        drawCarpet(g, 0, 0, dim)
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "Sierpinski Carpet"
        f.isResizable = false
        f.add(SierpinskiCarpet(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.isVisible = true
    }
}
