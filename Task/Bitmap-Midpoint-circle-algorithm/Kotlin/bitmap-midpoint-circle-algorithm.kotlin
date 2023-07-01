// version 1.1.4-3

import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage
import javax.swing.JOptionPane
import javax.swing.JLabel
import javax.swing.ImageIcon

class BasicBitmapStorage(width: Int, height: Int) {
    val image = BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR)

    fun fill(c: Color) {
        val g = image.graphics
        g.color = c
        g.fillRect(0, 0, image.width, image.height)
    }

    fun setPixel(x: Int, y: Int, c: Color) = image.setRGB(x, y, c.getRGB())

    fun getPixel(x: Int, y: Int) = Color(image.getRGB(x, y))
}

fun drawCircle(bbs: BasicBitmapStorage, centerX: Int, centerY: Int, radius: Int, circleColor: Color) {
    var d = (5 - radius * 4) / 4
    var x = 0
    var y = radius

    do {
        with(bbs) {
            setPixel(centerX + x, centerY + y, circleColor)
            setPixel(centerX + x, centerY - y, circleColor)
            setPixel(centerX - x, centerY + y, circleColor)
            setPixel(centerX - x, centerY - y, circleColor)
            setPixel(centerX + y, centerY + x, circleColor)
            setPixel(centerX + y, centerY - x, circleColor)
            setPixel(centerX - y, centerY + x, circleColor)
            setPixel(centerX - y, centerY - x, circleColor)
        }
        if (d < 0) {
            d += 2 * x + 1
        }
        else {
            d += 2 * (x - y) + 1
            y--
        }
        x++
    }
    while (x <= y)
}

fun main(args: Array<String>) {
    val bbs = BasicBitmapStorage(400, 400)
    bbs.fill(Color.pink)
    drawCircle(bbs, 200, 200, 100, Color.black)
    drawCircle(bbs, 200, 200,  50, Color.white)
    val label = JLabel(ImageIcon(bbs.image))
    val title = "Bresenham's circle algorithm"
    JOptionPane.showMessageDialog(null, label, title, JOptionPane.PLAIN_MESSAGE)
}
