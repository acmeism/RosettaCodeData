import java.awt.image.BufferedImage
import java.awt.Color

class RgbBitmap(val width:Int, val height:Int) {
   val image=new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR)

   def fill(c:Color)={
      val g=image.getGraphics()
      g.setColor(c)
      g.fillRect(0, 0, width, height)
   }

   def setPixel(x:Int, y:Int, c:Color)=image.setRGB(x, y, c.getRGB())
   def getPixel(x:Int, y:Int)=new Color(image.getRGB(x, y))
}
