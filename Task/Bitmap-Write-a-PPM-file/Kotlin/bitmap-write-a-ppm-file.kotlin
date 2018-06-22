// Version 1.2.40

import java.awt.Color
import java.awt.Graphics
import java.awt.image.BufferedImage
import java.io.FileOutputStream

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
    // create BasicBitmapStorage object
    val width = 640
    val height = 640
    val bbs = BasicBitmapStorage(width, height)
    for (y in 0 until height) {
        for (x in 0 until width) {
            val c = Color(x % 256, y % 256, (x * y) % 256)
            bbs.setPixel(x, y, c)
        }
    }

    // now write it to a PPM file
    val fos = FileOutputStream("output.ppm")
    val buffer = ByteArray(width * 3)  // write one line at a time
    fos.use {
        val header = "P6\n$width $height\n255\n".toByteArray()
        with (it) {
            write(header)
            for (y in 0 until height) {
                for (x in 0 until width) {
                    val c = bbs.getPixel(x, y)
                    buffer[x * 3] = c.red.toByte()
                    buffer[x * 3 + 1] = c.green.toByte()
                    buffer[x * 3 + 2] = c.blue.toByte()
                }
                write(buffer)
            }
        }
    }
}
