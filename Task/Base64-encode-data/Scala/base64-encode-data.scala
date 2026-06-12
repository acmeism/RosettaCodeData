import java.net.URL
import java.util.Base64

object Base64S extends App {
  val conn = new URL("http://rosettacode.org/favicon.ico").openConnection
  val bytes = conn.getInputStream.readAllBytes()

  val result = Base64.getEncoder.encodeToString(bytes)
  println(s"${result.take(22)} ... ${result.drop(4830)}")

  assert(Base64.getDecoder.decode(result) sameElements bytes)

  println(s"Successfully completed without errors. [total ${compat.Platform.currentTime - executionStart} ms]")
}
