import java.awt.image.BufferedImage
import java.awt.Color

object RgbBitmap extends App {
  class RgbBitmap(val dim: (Int, Int)) {
    def width = dim._1
    def height = dim._2

    private val image = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR)

    def apply(x: Int, y: Int) = new Color(image.getRGB(x, y))

    def update(x: Int, y: Int, c: Color) = image.setRGB(x, y, c.getRGB)

    def fill(c: Color) = {
      val g = image.getGraphics
      g.setColor(c)
      g.fillRect(0, 0, width, height)
    }
  }

  object RgbBitmap {
    def apply(width: Int, height: Int) = new RgbBitmap(width, height)
  }


  /** Even Javanese style testing is still possible.
    */
  private val img0 = new RgbBitmap(50, 60) { // Wrappers to enable adhoc Javanese style
    def getPixel(x: Int, y: Int) = this(x, y)
    def setPixel(x: Int, y: Int, c: Color) = this(x, y) = c
  }

  img0.fill(Color.CYAN)
  img0.setPixel(5, 6, Color.BLUE)
  // Testing in Java style
  assert(img0.getPixel(0, 1) == Color.CYAN)
  assert(img0.getPixel(5, 6) == Color.BLUE)
  assert(img0.width == 50)
  assert(img0.height == 60)
  println("Tests successfully completed with no errors found.")
}
