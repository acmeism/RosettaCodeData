import org.fusesource.jansi.internal.CLibrary._

object IsATty  extends App {

  var enabled = true

  def apply(enabled: Boolean): Boolean = {
    // We must be on some unix variant..
    try {
      enabled && isatty(STDIN_FILENO) == 1
    }
    catch {
      case ignore: Throwable =>
        ignore.printStackTrace()
        false

    }
  }

    println("tty " + apply(true))
}
