import java.awt.Color
import scala.collection.mutable

object Flood {
  def floodFillStack(bm:RgbBitmap, x: Int, y: Int, targetColor: Color): Unit = {
    // validate
    if (bm.getPixel(x,y) == targetColor) return

    // vars
    val oldColor = bm.getPixel(x,y)
    val pixels = new mutable.Stack[(Int,Int)]

    // candy coating methods
    def paint(fx: Int, fy:Int) = bm.setPixel(fx,fy,targetColor)
    def old(cx: Int, cy: Int): Boolean = bm.getPixel(cx,cy) == oldColor
    def push(px: Int, py: Int) = pixels.push((px,py))

    // starting point
    push(x,y)

    // work
    while (pixels.nonEmpty) {
      val (x, y) = pixels.pop()
      var y1 = y
      while (y1 >= 0 && old(x, y1)) y1 -= 1
      y1 += 1
      var spanLeft = false
      var spanRight = false
      while (y1 < bm.height && old(x, y1)) {
        paint(x,y1)
        if (x > 0 && spanLeft != old(x-1,y1)) {
          if (old(x - 1, y1)) push(x - 1, y1)
          spanLeft = !spanLeft
        }
        if (x < bm.width - 1 && spanRight != old(x+1,y1)) {
          if (old(x + 1, y1)) push(x + 1, y1)
          spanRight = !spanRight
        }
        y1 += 1
      }
    }
  }
}
