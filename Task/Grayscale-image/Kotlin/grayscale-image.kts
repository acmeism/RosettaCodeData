// version 1.2.10

import java.io.File
import java.awt.image.BufferedImage
import javax.imageio.ImageIO

fun BufferedImage.toGrayScale() {
    for (x in 0 until width) {
        for (y in 0 until height) {
            var argb  = getRGB(x, y)
            val alpha = (argb shr 24) and 0xFF
            val red   = (argb shr 16) and 0xFF
            val green = (argb shr  8) and 0xFF
            val blue  =  argb and 0xFF
            val lumin = (0.2126 * red + 0.7152 * green + 0.0722 * blue).toInt()
            argb = (alpha shl 24) or (lumin shl 16) or (lumin shl 8) or lumin
            setRGB(x, y, argb)
        }
    }
}

fun main(args: Array<String>) {
    val image = ImageIO.read(File("bbc.jpg")) // using BBC BASIC image
    image.toGrayScale()
    val grayFile = File("bbc_gray.jpg")
    ImageIO.write(image, "jpg", grayFile)
}
