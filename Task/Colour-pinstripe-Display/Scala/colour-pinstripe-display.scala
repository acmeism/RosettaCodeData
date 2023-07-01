import java.awt.Color._
import java.awt._

import javax.swing._

object ColourPinstripeDisplay extends App {
  private def palette = Seq(black, red, green, blue, magenta, cyan, yellow, white)

  SwingUtilities.invokeLater(() =>
    new JFrame("Colour Pinstripe") {

      class ColourPinstripe_Display extends JPanel {

        override def paintComponent(g: Graphics): Unit = {
          val bands = 4

          super.paintComponent(g)
          for (b <- 1 to bands) {
            var colIndex = 0
            for (x <- 0 until getWidth by b) {
              g.setColor(ColourPinstripeDisplay.palette(colIndex % ColourPinstripeDisplay.palette.length))
              g.fillRect(x, (b - 1) * (getHeight / bands), x + b, b * (getHeight / bands))
              colIndex += 1
            }
          }
        }

        setPreferredSize(new Dimension(900, 600))
      }

      add(new ColourPinstripe_Display, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setVisible(true)
    }
  )

}
