// version 1.1.0

import java.awt.*
import javax.swing.*

class ColourPinstripeDisplay(): JPanel() {
    private companion object {
        val palette = arrayOf(Color.white, Color.black)
    }

    private val bands = 4

    init {
        preferredSize = Dimension(900, 600)
    }

    protected override fun paintComponent(g: Graphics) {
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
        f.title = "PinstripeDisplay"
        f.add(ColourPinstripeDisplay(), BorderLayout.CENTER)
        f.pack()
        f.setLocationRelativeTo(null)
        f.setVisible(true)
    }
}
