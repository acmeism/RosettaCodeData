// Version 1.2.41

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
    val bbs = BasicBitmapStorage(320, 240)
    with (bbs) {
        fill(Color.white) // say
        setPixel(100, 100, Color.red)
        // check it worked
        val c = getPixel(100, 100)
        print("The color of the pixel at (100, 100) is ")
        println(if (c == Color.red) "red" else "white")
    }
}
