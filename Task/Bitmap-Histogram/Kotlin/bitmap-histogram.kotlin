// version 1.2.10

import java.io.File
import java.awt.image.BufferedImage
import javax.imageio.ImageIO

const val BLACK = 0xff000000.toInt()
const val WHITE = 0xffffffff.toInt()

fun luminance(argb: Int): Int {
    val red   = (argb shr 16) and 0xFF
    val green = (argb shr  8) and 0xFF
    val blue  =  argb and 0xFF
    return (0.2126 * red + 0.7152 * green + 0.0722 * blue).toInt()
}

val BufferedImage.histogram: IntArray
    get() {
        val lumCount = IntArray(256)
        for (x in 0 until width) {
            for (y in 0 until height) {
                var argb = getRGB(x, y)
                lumCount[luminance(argb)]++
            }
        }
        return lumCount
    }

fun findMedian(histogram: IntArray): Int {
    var lSum  = 0
    var rSum  = 0
    var left  = 0
    var right = 255
    do {
        if (lSum < rSum) lSum += histogram[left++]
        else             rSum += histogram[right--]
    }
    while (left != right)
    return left
}

fun BufferedImage.toBlackAndWhite(median: Int) {
    for (x in 0 until width) {
        for (y in 0 until height) {
            val argb = getRGB(x, y)
            val lum  = luminance(argb)
            if (lum < median)
                setRGB(x, y, BLACK)
            else
                setRGB(x, y, WHITE)
        }
    }
}

fun main(args: Array<String>) {
    val image = ImageIO.read(File("Lenna100.jpg"))
    val median = findMedian(image.histogram)
    image.toBlackAndWhite(median)
    val bwFile = File("Lenna_bw.jpg")
    ImageIO.write(image, "jpg", bwFile)
}
