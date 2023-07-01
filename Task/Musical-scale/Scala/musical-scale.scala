import net.java.dev.sna.SNA

object PlayMusicScale extends App with SNA {

  snaLibrary = "Kernel32"
  val Beep = SNA[Int, Int, Unit]

  println("Please don't shoot the piano player, he's doing the best that he can!")
  List(0, 2, 4, 5, 7, 9, 11, 12).
    foreach(f => Beep((261.63 * math.pow(2, f / 12.0)).toInt, if (f == 12) 1000 else 500))
  println("That's all")
}
