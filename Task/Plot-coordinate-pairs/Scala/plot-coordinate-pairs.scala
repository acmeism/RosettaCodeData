import scala.swing._
import scala.swing.Swing._
import scala.swing.{MainFrame, Panel, SimpleGUIApplication}
import scala.swing.event._
import java.awt.{Color, Dimension, Graphics, Graphics2D, Point, geom}

object PlotCoordPairs extends SimpleSwingApplication {

  //min/max of display-x resp. y
  val dx0 = 70
  val dy0 = 30
  val dxm = 670
  val dym = 430

  val prefSizeX = 720
  val prefSizeY = 480

  lazy val ui = new Panel {
    background = Color.white
    preferredSize = (prefSizeX, prefSizeY)

    import math._
    val xmax = {
      val f1 = pow(10,log10(xs.max).toInt)
      val f2 = if (f1<10) 10 else round(xs.max/f1)*f1
      if (f2 >= xs.max) f2 else (round(xs.max/f1)+1)*f1
    }
    val ymax = {
      val f1 = pow(10,log10(ys.max).toInt)
      val f2 = if (f1<10) 10 else round(ys.max/f1)*f1
      if (f2 >= ys.max) f2 else (round(ys.max/f1)+1)*f1
    }
    val xinterv = xmax/xs.size
    val yinterv = ymax/xs.size

    case class Coord(x: Double, y: Double) {
      val dx = (x/xmax*(dxm-dx0)+dx0).toInt
      val dy = (dym-y/ymax*(dym-dy0)).toInt
    }

    val pcentre = Coord(0,0)
    val pxmax = Coord(xmax,0)
    val pymax = Coord(0, ymax)

    //axes:
    var a_path = new geom.GeneralPath
    a_path.moveTo(pcentre.dx, pcentre.dy)
    a_path.lineTo(pxmax.dx, pxmax.dy) //x-axis
    a_path.moveTo(pcentre.dx, pcentre.dy)
    a_path.lineTo(pymax.dx, pymax.dy) //y-axis
    // interval signs:
    (0 to xs.size-1).map(i=>Coord(i*xinterv, 0)).map(p=>{a_path.moveTo(p.dx,p.dy);a_path.lineTo(p.dx,p.dy+5)})
    (0 to xs.size-1).map(i=>Coord(0, i*yinterv)).map(p=>{a_path.moveTo(p.dx,p.dy);a_path.lineTo(p.dx-5,p.dy)})

    //grid:
    var g_path = new geom.GeneralPath
    (1 to xs.size).map(i=>Coord(i*xinterv, 0)).map(p=>{g_path.moveTo(p.dx,p.dy);g_path.lineTo(Coord(p.x,ymax).dx,Coord(p.x,ymax).dy)})
    (1 to xs.size).map(i=>Coord(0, i*yinterv)).map(p=>{g_path.moveTo(p.dx,p.dy);g_path.lineTo(Coord(xmax,p.y).dx,Coord(xmax,p.y).dy)})

    //labeling:
    val xlabels = (0 to xs.size).map(i=>{val p=Coord(i*xinterv,0); Triple(p.x.toInt.toString,p.dx-3,p.dy+20)})
    val ylabels = (0 to xs.size).map(i=>{val p=Coord(0,i*yinterv); Triple(p.y.toInt.toString,p.dx-30,p.dy+5)})

    //curve:
    var path = new geom.GeneralPath
    val curve = (0 to xs.size-1).map(i=>Coord(xs(i),ys(i)))
    path.moveTo(curve(0).dx,curve(0).dy)
    curve.map(p=>path.lineTo(p.dx,p.dy))
    //...flag all function values:
    val rects = curve.map(p=>new Rectangle(p.dx-3, p.dy-3, 6, 6))

    override def paintComponent(g: Graphics2D) = {
      super.paintComponent(g)

      g.setColor(Color.lightGray)
      g.draw(g_path)
      g.setColor(Color.black)
      g.draw(a_path)
      xlabels.map(t=>g.drawString(t._1,t._2,t._3))
      ylabels.map(t=>g.drawString(t._1,t._2,t._3))
      g.draw(path)
      rects.map(g.draw(_))
    }
  }

  val xs = List(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
  val ys = List(2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0)

  def top = new MainFrame {
    title = "Rosetta Code >>> Task: Plot coordinate pairs | Language: Scala"
    contents = ui
  }

}
