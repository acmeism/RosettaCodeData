object UTF8EncodeAndDecode extends App {

  val codePoints = Seq(0x0041, 0x00F6, 0x0416, 0x20AC, 0x1D11E)

  def utf8Encode(codepoint: Int): Array[Byte] =
    new String(Array[Int](codepoint), 0, 1).getBytes(StandardCharsets.UTF_8)

  def utf8Decode(bytes: Array[Byte]): Int =
    new String(bytes, StandardCharsets.UTF_8).codePointAt(0)

  println("Char Name                                 Unicode  UTF-8       Decoded")
  for (codePoint <- codePoints) {
    val w = if (Character.isBmpCodePoint(codePoint)) 4 else 5 // Compute spacing
    val bytes = utf8Encode(codePoint)

    def leftAlignedHex = f"U+${codePoint}%04X"

    val s = new StringBuilder()
    bytes.foreach(byte => s ++= "%02X ".format(byte))

    printf(s"%-${w}c %-36s %-7s  %-${16 - w}s%c%n",
      codePoint, Character.getName(codePoint), leftAlignedHex, s, utf8Decode(bytes))
  }
