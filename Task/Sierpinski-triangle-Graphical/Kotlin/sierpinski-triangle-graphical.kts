import java.awt.*
import javax.swing.JFrame
import javax.swing.JPanel

fun main(args: Array<String>) {
    var i = 8     // Default
    if (args.any()) {
        try {
            i = args.first().toInt()
        } catch (e: NumberFormatException) {
            i = 8
            println("Usage: 'java SierpinskyTriangle [level]'\nNow setting level to $i")
        }
    }

    object : JFrame("Sierpinsky Triangle - Kotlin") {
        val panel = object : JPanel() {
            val size = 800

            init {
                preferredSize = Dimension(size, size)
            }

            public override fun paintComponent(g: Graphics) {
                g.color = Color.BLACK
                if (g is Graphics2D) {
                    g.drawSierpinskyTriangle(i, 20, 20, size - 40)
                }
            }
        }

        init {
            defaultCloseOperation = JFrame.EXIT_ON_CLOSE
            add(panel)
            pack()
            isResizable = false
            setLocationRelativeTo(null)
            isVisible = true
        }
    }
}

internal fun Graphics2D.drawSierpinskyTriangle(level: Int, x: Int, y: Int, size: Int) {
    if (level > 0) {
        drawLine(x, y, x + size, y)
        drawLine(x, y, x, y + size)
        drawLine(x + size, y, x, y + size)

        drawSierpinskyTriangle(level - 1, x, y, size / 2)
        drawSierpinskyTriangle(level - 1, x + size / 2, y, size / 2)
        drawSierpinskyTriangle(level - 1, x, y + size / 2, size / 2)
    }
}
