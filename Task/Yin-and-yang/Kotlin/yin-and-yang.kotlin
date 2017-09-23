// version 1.1.2

import java.awt.Color
import java.awt.Graphics
import java.awt.Image
import java.awt.image.BufferedImage
import javax.swing.ImageIcon
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.JLabel

class YinYangGenerator {
    private fun drawYinYang(size: Int, g: Graphics) {
        with(g) {
            // Preserve the color for the caller
            val colorSave = color
            color = Color.WHITE

            // Use fillOval to draw a filled in circle
            fillOval(0, 0, size - 1, size - 1)
            color = Color.BLACK

            // Use fillArc to draw part of a filled in circle
            fillArc(0, 0, size - 1, size - 1, 270, 180)
            fillOval(size / 4, size / 2, size / 2, size / 2)
            color = Color.WHITE
            fillOval(size / 4, 0, size / 2, size / 2)
            fillOval(7 * size / 16, 11 * size / 16, size /8, size / 8)
            color = Color.BLACK
            fillOval(7 * size / 16, 3 * size / 16, size / 8, size / 8)

            // Use drawOval to draw an empty circle for the outside border
            drawOval(0, 0, size - 1, size - 1)

            // Restore the color for the caller
            color = colorSave
        }
    }

    fun createImage(size: Int, bg: Color): Image {
        // A BufferedImage creates the image in memory
        val image = BufferedImage(size, size, BufferedImage.TYPE_INT_RGB)

        // Get the graphics object for the image
        val g = image.graphics

        // Color in the background of the image
        g.color = bg
        g.fillRect(0, 0, size, size)
        drawYinYang(size, g)
        return image
    }
}

fun main(args: Array<String>) {
    val gen = YinYangGenerator()
    val size = 400 // say
    val p = JPanel()
    val yinYang = gen.createImage(size, p.background)
    p.add(JLabel(ImageIcon(yinYang)))

    val size2 = size / 2 // say
    val yinYang2 = gen.createImage(size2, p.background)
    p.add(JLabel(ImageIcon(yinYang2)))

    val f = JFrame("Big and Small Yin Yang")
    with (f) {
        defaultCloseOperation = JFrame.EXIT_ON_CLOSE
        add(p)
        pack()
        isVisible = true
    }
}
