import java.awt.Color
import scala.swing._

class ColorBars extends Component {
  override def paintComponent(g:Graphics2D)={
    val colors=List(Color.BLACK, Color.RED, Color.GREEN, Color.BLUE, Color.MAGENTA, Color.CYAN, Color.YELLOW, Color.WHITE)
    val colCount=colors.size
    val deltaX=size.width.toDouble/colCount
    for(x <- 0 until colCount){
      val startX=(deltaX*x).toInt
      val endX=(deltaX*(x+1)).toInt
      g.setColor(colors(x))
      g.fillRect(startX, 0, endX-startX, size.height)
    }
  }
}
