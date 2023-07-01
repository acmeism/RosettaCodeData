import scala.swing._

class GreyscaleBars extends Component {
  override def paintComponent(g:Graphics2D)={
    val barHeight=size.height>>2
    for(run <- 0 to 3; colCount=8<<run){
      val deltaX=size.width.toDouble/colCount
      val colBase=if (run%2==0) -255 else 0
      for(x <- 0 until colCount){
        val col=(colBase+(255.0/(colCount-1)*x).toInt).abs
        g.setColor(new Color(col,col,col))
		
        val startX=(deltaX*x).toInt
        val endX=(deltaX*(x+1)).toInt
        g.fillRect(startX, barHeight*run, endX-startX, barHeight)
      }
    }
  }
}
