val r = 120
val img = new RgbBitmap(r*2+1, r*2+1)
val line = drawLine(plotter(img, Color.GRAY)_)_
img.fill(Color.WHITE)
for (angle <- 0 to 360 by 30; θ = math toRadians angle; θ2 = θ + math.Pi) {
  val a = Point(r + r * math.sin(θ), r + r * math.cos(θ))
  val b = Point(r + r * math.sin(θ2), r + r * math.cos(θ2))
  line(a, b)
}
javax.imageio.ImageIO.write(img.image, "png", new java.io.File("XiaolinWuLineAlgorithm.png"))
