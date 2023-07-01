import java.nio.charset.StandardCharsets

object UTF8EncodeAndDecode extends App {

  val codePoints = Seq(0x0041, 0x00F6, 0x0416, 0x20AC, 0x1D11E)

  def utf8Encode(codepoint: Int): Array[Byte] =
    new String(Array[Int](codepoint), 0, 1).getBytes(StandardCharsets.UTF_8)

  def utf8Decode(bytes: Array[Byte]): Int =
    new String(bytes, StandardCharsets.UTF_8).codePointAt(0)

  println("Char Name                                 Unicode  UTF-8       Decoded")
  codePoints.foreach{ codePoint =>
    val w = if (Character.isBmpCodePoint(codePoint)) 4 else 5 // Compute spacing
    val bytes = utf8Encode(codePoint)

    def leftAlignedHex: String = f"U+${codePoint}%04X"

    def utf: String = bytes.foldLeft("")(_ + "%02X ".format(_))

    printf(s"%-${w}c %-36s %-7s  %-${16 - w}s%c%n",
      codePoint, Character.getName(codePoint), leftAlignedHex, utf, utf8Decode(bytes))  }

  println(s"\nSuccessfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")
}
