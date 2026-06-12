// Version 1.2.41

import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage
import java.util.Random

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
    val rand = Random()
    val bbs = BasicBitmapStorage(640, 480)
    with (bbs) {
        fill(Color.white) // say
        val x = rand.nextInt(image.width)
        val y = rand.nextInt(image.height)
        setPixel(x, y, Color.yellow)
        // check there's exactly one random yellow pixel
        for (i in 0 until image.width) {
            for (j in 0 until image.height) {
                if (getPixel(i, j) == Color.yellow) {
                    println("The color of the pixel at ($i, $j) is yellow")
                }
            }
        }
    }
}
