import java.awt.Color
import scala.actors.Actor
import scala.swing.{ Graphics2D, MainFrame, Panel, SimpleSwingApplication }
import scala.swing.Swing.pair2Dimension

object Pendulum extends SimpleSwingApplication {
  val length = 100

  lazy val ui = new Panel {
    import scala.math.{ cos, Pi, sin }
    background = Color.white
    preferredSize = (2 * length + 50, length / 2 * 3)
    peer.setDoubleBuffered(true)

    var angle: Double = Pi / 2

    def pendular = new Actor {
      var angleVelocity = 0.0
      val dt = 0.1

      def act() {
        while (true) {
          angleVelocity += (-9.81 / length * sin(angle)) * dt
          angle += angleVelocity * dt
          repaint()
          Thread.sleep(15)
        }
      }
    }

    override def paintComponent(g: Graphics2D) = {
      super.paintComponent(g)

      val (anchorX, anchorY) = (size.width / 2, size.height / 4)
      val (ballX, ballY) =
        (anchorX + (sin(angle) * length).toInt, anchorY + (cos(angle) * length).toInt)
      g.setColor(Color.lightGray)
      g.drawLine(anchorX - 2 * length, anchorY, anchorX + 2 * length, anchorY)
      g.setColor(Color.black)
      g.drawLine(anchorX, anchorY, ballX, ballY)
      g.fillOval(anchorX - 3, anchorY - 4, 7, 7)
      g.drawOval(ballX - 7, ballY - 7, 14, 14)
      g.setColor(Color.yellow)
      g.fillOval(ballX - 7, ballY - 7, 14, 14)
    }
  }

  def top = new MainFrame {
    title = "Rosetta Code >>> Task: Animate a pendulum | Language: Scala"
    contents = ui
    centerOnScreen
    ui.pendular.start
  }
}
