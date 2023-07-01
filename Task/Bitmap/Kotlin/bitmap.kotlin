// version 1.1.4-3

import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage

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

fun main(args: Array<String>) {
    val width = 640
    val height = 480
    val bbs = BasicBitmapStorage(width, height)
    with (bbs) {
        fill(Color.cyan)
        setPixel(width / 2, height / 2, Color.black)
        val c1 = getPixel(width / 2, height / 2)
        val c2 = getPixel(20, 20)
        print("The color of the pixel at (${width / 2}, ${height / 2}) is ")
        println(if (c1 == Color.black) "black" else "unknown")
        print("The color of the pixel at (120, 120) is ")
        println(if (c2 == Color.cyan) "cyan" else "unknown")
    }
}
