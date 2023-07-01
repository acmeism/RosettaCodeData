object ArchimedeanSpiral extends App {

  SwingUtilities.invokeLater(() =>
    new JFrame("Archimedean Spiral") {

      class ArchimedeanSpiral extends JPanel {
        setPreferredSize(new Dimension(640, 640))
        setBackground(Color.white)

        private def drawGrid(g: Graphics2D): Unit = {
          val (angle, margin, numRings) = (toRadians(45), 10, 8)
          val w = getWidth
          val (center, spacing) = (w / 2, (w - 2 * margin) / (numRings * 2))

          g.setColor(new Color(0xEEEEEE))
          for (i <- 0 until numRings) {
            val pos = margin + i * spacing
            val size = w - (2 * margin + i * 2 * spacing)
            g.drawOval(pos, pos, size, size)
            val ia = i * angle
            val x2 = center + (cos(ia) * (w - 2 * margin) / 2).toInt
            val y2 = center - (sin(ia) * (w - 2 * margin) / 2).toInt
            g.drawLine(center, center, x2, y2)
          }
        }

        private def drawSpiral(g: Graphics2D): Unit = {
          val (degrees: Double, center) = (toRadians(0.1), getWidth / 2)
          val (a, b, c, end) = (0, 20, 1, 360 * 2 * 10 * degrees)

          def plot(g: Graphics2D, x: Int, y: Int): Unit = g.drawOval(x, y, 1, 1)

          def iter(theta: Double): Double = {
            if (theta < end) {
              val r = a + b * pow(theta, 1 / c)
              val x = r * cos(theta)
              val y = r * sin(theta)
              plot(g, (center + x).toInt, (center - y).toInt)
              iter(theta + degrees)
            } else theta
          }

          g.setStroke(new BasicStroke(2))
          g.setColor(Color.orange)
          iter(0)
        }

        override def paintComponent(gg: Graphics): Unit = {
          super.paintComponent(gg)
          val g = gg.asInstanceOf[Graphics2D]
          g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON)
          drawGrid(g)
          drawSpiral(g)
        }
      }

      add(new ArchimedeanSpiral, BorderLayout.CENTER)
      pack()
      setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE)
      setLocationRelativeTo(null)
      setResizable(false)
      setVisible(true)
    }
  )

}
