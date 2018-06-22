object VideoDisplayModes extends App {

  import java.util.Scanner

  def runSystemCommand(command: String) {
    val proc = Runtime.getRuntime.exec(command)

    val a: Unit = {
      val a = new Scanner(proc.getInputStream)
      while (a.hasNextLine) println(a.nextLine())
    }
    proc.waitFor()
    println()
  }

  // query supported display modes
  runSystemCommand("xrandr -q")
  Thread.sleep(3000)

  // change display mode to 1024x768 say (no text output)
  runSystemCommand("xrandr -s 1024x768")
  Thread.sleep(3000)

  // change it back again to 1366x768 (or whatever is optimal for your system)
  runSystemCommand("xrandr -s 1366x768")

}
