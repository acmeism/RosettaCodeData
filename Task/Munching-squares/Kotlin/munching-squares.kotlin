// version 1.1.4-3

import javax.swing.JFrame
import javax.swing.JPanel
import java.awt.Graphics
import java.awt.Graphics2D
import java.awt.Color
import java.awt.Dimension
import java.awt.BorderLayout
import java.awt.RenderingHints
import javax.swing.SwingUtilities

class XorPattern : JPanel() {

    init {
        preferredSize = Dimension(256, 256)
        background = Color.white
    }

    override fun paint(gg: Graphics) {
        super.paintComponent(gg)
        val g = gg as Graphics2D
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                           RenderingHints.VALUE_ANTIALIAS_ON)
        for (y in 0 until width) {
            for (x in 0 until height) {
                g.color = Color(0, (x xor y) % 256, 255)
                g.drawLine(x, y, x, y)
            }
        }
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        with (f) {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            title = "Munching squares"
            isResizable = false
            add(XorPattern(), BorderLayout.CENTER)
            pack()
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}
