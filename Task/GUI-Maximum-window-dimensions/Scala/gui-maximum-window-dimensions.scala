import java.awt.{Dimension, Insets, Toolkit}

import javax.swing.JFrame

class MaxWindowDims() extends JFrame {
  val toolkit: Toolkit = Toolkit.getDefaultToolkit
  val (insets0, screenSize) = (toolkit.getScreenInsets(getGraphicsConfiguration),  toolkit.getScreenSize)

  println("Physical screen size: " + screenSize)
  System.out.println("Insets: " + insets0)
  screenSize.width -= (insets0.left + insets0.right)
  screenSize.height -= (insets0.top + insets0.bottom)
  System.out.println("Max available: " + screenSize)
}

object MaxWindowDims {
  def main(args: Array[String]): Unit = {
    new MaxWindowDims
  }
}
