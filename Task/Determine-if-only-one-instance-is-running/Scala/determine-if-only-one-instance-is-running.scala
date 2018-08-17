import java.io.IOException
import java.net.{InetAddress, ServerSocket}

object SingletonApp extends App {
  private val port = 65000

  try {
    val s = new ServerSocket(port, 10, InetAddress.getLocalHost)
  }
  catch {
    case _: IOException =>
      // port taken, so app is already running
      println("Application is already running, so terminating this instance.")
      sys.exit(-1)
  }

  println("OK, only this instance is running but will terminate in 10 seconds.")

  Thread.sleep(10000)

  sys.exit(0)

}
