import java.net.{URLDecoder, URLEncoder}
import scala.compat.Platform.currentTime

object UrlCoded extends App {
  val original = """http://foo bar/"""
  val encoded: String = URLEncoder.encode(original, "UTF-8")

  assert(encoded == "http%3A%2F%2Ffoo+bar%2F", s"Original: $original not properly encoded: $encoded")

  val percentEncoding = encoded.replace("+", "%20")
  assert(percentEncoding == "http%3A%2F%2Ffoo%20bar%2F", s"Original: $original not properly percent-encoded: $percentEncoding")

  assert(URLDecoder.decode(encoded, "UTF-8") == URLDecoder.decode(percentEncoding, "UTF-8"))

  println(s"Successfully completed without errors. [total ${currentTime - executionStart} ms]")
}
