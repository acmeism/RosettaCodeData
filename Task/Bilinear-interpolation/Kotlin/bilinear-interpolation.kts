// version 1.2.21

import java.io.File
import java.awt.image.BufferedImage
import javax.imageio.ImageIO

/* gets the 'n'th byte of a 4-byte integer */
operator fun Int.get(n: Int) = (this shr (n * 8)) and 0xFF

fun lerp(s: Float, e: Float, t: Float) = s + (e - s) * t

fun blerp(c00: Float, c10: Float, c01: Float, c11: Float, tx: Float, ty: Float) =
    lerp(lerp(c00, c10, tx), lerp(c01,c11, tx), ty)

fun BufferedImage.scale(scaleX: Float, scaleY: Float): BufferedImage {
    val newWidth  = (width * scaleX).toInt()
    val newHeight = (height * scaleY).toInt()
    val newImage  = BufferedImage(newWidth, newHeight, type)
    for (x in 0 until newWidth) {
        for (y in 0 until newHeight) {
            val gx = x.toFloat() / newWidth * (width - 1)
            val gy = y.toFloat() / newHeight * (height - 1)
            val gxi = gx.toInt()
            val gyi = gy.toInt()
            var rgb = 0
            val c00 = getRGB(gxi, gyi)
            val c10 = getRGB(gxi + 1, gyi)
            val c01 = getRGB(gxi, gyi + 1)
            val c11 = getRGB(gxi + 1, gyi + 1)
            for (i in 0..2) {
                val b00 = c00[i].toFloat()
                val b10 = c10[i].toFloat()
                val b01 = c01[i].toFloat()
                val b11 = c11[i].toFloat()
                val ble = blerp(b00, b10, b01, b11, gx - gxi, gy - gyi).toInt() shl (8 * i)
                rgb = rgb or ble
            }
            newImage.setRGB(x, y, rgb)
        }
    }
    return newImage
}

fun main(args: Array<String>) {
    val lenna = File("Lenna100.jpg")  // from the Percentage difference between images task
    val image = ImageIO.read(lenna)
    val image2 = image.scale(1.6f, 1.6f)
    val lenna2 = File("Lenna100_larger.jpg")
    ImageIO.write(image2, "jpg", lenna2)
}
