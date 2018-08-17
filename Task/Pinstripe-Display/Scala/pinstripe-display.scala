import java.awt._

import javax.swing._

object PinstripeDisplay extends App {

  SwingUtilities.invokeLater(() =>
    new JFrame("Pinstripe") {

      class Pinstripe_Display extends JPanel {

        override def paintComponent(g: Graphics): Unit = {
          val bands = 4

          super.paintComponent(g)
          for (b <- 1 to bands) {
            var colIndex = 0
            for (x <- 0 until getWidth by b) {
              g.setColor(if (colIndex % 2 == 0) Color.white
              else Color.black)
              g.fillRect(x, (b - 1) * (getHeight / bands), x + b, b * (getHeight / bands))
              colIndex += 1
            }
          }
        }

        setPreferredSize(new Dimension(900, 600))
      }

      add(new Pinstripe_Display, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setVisible(true)
    })

}
