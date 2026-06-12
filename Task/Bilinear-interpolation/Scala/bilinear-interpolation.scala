import java.awt.image.BufferedImage
import java.io.{File, IOException}

import javax.imageio.ImageIO

object BilinearInterpolation {
  @throws[IOException]
  def main(args: Array[String]): Unit = {
    val lenna = new File("Lenna100.jpg")
    val image = ImageIO.read(lenna)
    val image2 = scale(image, 1.6f, 1.6f)
    val lenna2 = new File("Lenna100_larger.jpg")
    ImageIO.write(image2, "jpg", lenna2)
  }

  private def scale(self: BufferedImage, scaleX: Float, scaleY: Float) = {
    val newWidth = (self.getWidth * scaleX).toInt
    val newHeight = (self.getHeight * scaleY).toInt
    val newImage = new BufferedImage(newWidth, newHeight, self.getType)
    var x = 0
    while (x < newWidth) {
      var y = 0
      while (y < newHeight) {
        val gx = x.toFloat / newWidth * (self.getWidth - 1)
        val gy = y.toFloat / newHeight * (self.getHeight - 1)
        val gxi = gx.toInt
        val gyi = gy.toInt
        var rgb = 0
        val c00 = self.getRGB(gxi, gyi)
        val c10 = self.getRGB(gxi + 1, gyi)
        val c01 = self.getRGB(gxi, gyi + 1)
        val c11 = self.getRGB(gxi + 1, gyi + 1)
        var i = 0
        while (i <= 2) {
          val b00 = get(c00, i)
          val b10 = get(c10, i)
          val b01 = get(c01, i)
          val b11 = get(c11, i)
          val ble = blerp(b00, b10, b01, b11, gx - gxi, gy - gyi).toInt << (8 * i)
          rgb = rgb | ble

          i += 1
        }
        newImage.setRGB(x, y, rgb)

        y += 1
      }
      x += 1
    }
    newImage
  }

  /* gets the 'n'th byte of a 4-byte integer */
  private def get(self: Int, n: Int) = (self >> (n * 8)) & 0xFF

  private def blerp(c00: Float, c10: Float, c01: Float, c11: Float, tx: Float, ty: Float) = lerp(lerp(c00, c10, tx), lerp(c01, c11, tx), ty)

  private def lerp(s: Float, e: Float, t: Float) = s + (e - s) * t
}
