// version 1.1.0

import java.awt.*
import java.awt.Color.*
import javax.swing.*

class ColourPinstripeDisplay : JPanel() {
    private companion object {
        val palette = arrayOf(black, red, green, blue, magenta, cyan, yellow, white)
    }

    private val bands = 4

    init {
        preferredSize = Dimension(900, 600)
    }

    override fun paintComponent(g: Graphics) {
        super.paintComponent(g)
        for (b in 1..bands) {
            var colIndex = 0
            val h = height / bands
            for (x in 0 until width step b) {
                g.color = palette[colIndex % palette.size]
                g.fillRect(x, (b - 1) * h, b, h)
                colIndex++
            }
        }
    }
}

fun main(args: Array<String>) {
    SwingUtilities.invokeLater {
        val f = JFrame()
        f.defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        f.title = "ColourPinstripeDisplay"
        f.add(ColourPinstripeDisplay(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.isVisible = true
    }
}
