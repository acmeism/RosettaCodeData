object LinePrinter extends App {
  import java.io.{ FileWriter, IOException }
  {
    val lp0 = new FileWriter("/dev/lp0")
    lp0.write("Hello, world!")
    lp0.close()
  }
}
