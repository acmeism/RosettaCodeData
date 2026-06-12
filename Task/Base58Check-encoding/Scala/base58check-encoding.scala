import java.math.BigInteger

object Base58 extends App {
  private val codeString = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
  private val (big0, big58) = (BigInt(0), BigInteger.valueOf(58))

  def convertToBase58(input: String): String = convertToBase58(input, 16)

  def convertToBase58(input: String, base: Int) = {
    if (input.isEmpty) "" else {
      val big =
        if (base == 16 && input.startsWith("0x")) BigInt(input.substring(2), 16) else BigInt(input, base)

      @scala.annotation.tailrec
      def encode(current: BigInt, sb: StringBuilder): StringBuilder = current match {
        case `big0` => sb
        case _ =>
          val Array(dividend, remainder: BigInteger) = current.bigInteger.divideAndRemainder(big58)
          encode(dividend, sb.append(codeString(remainder.intValue)))
      }

      encode(big, new StringBuilder).reverse.toString
    }
  }

  private def decode(input: String): Array[Byte] = {
    val (mapping, trimmed)= (codeString.zipWithIndex.toMap, input.dropWhile(_ == '1').toList)

    def zeroes: Array[Byte] = input.takeWhile(_ == '1').map(_ => 0.toByte).toArray
    def decoded: BigInt = trimmed.foldLeft(big0)((a, b) => a * big58 + BigInt(mapping(b)))

    if (trimmed.nonEmpty) zeroes ++ decoded.toByteArray.dropWhile(_ == 0) else zeroes
  }

  private def bytes2Hex(buf: Array[Byte]): String = "0x" + buf.map("%02x" format _).mkString

  /*
   * Running some test examples.
   */

  private val veryLongNumber = "25420294593250030202636073700053352635053786165627414518"
  println(f"$veryLongNumber%-56s -> ${convertToBase58(veryLongNumber, 10)}%s" )

  private val hashes = List("0x61", "0x626262", "0x636363", "0x73696d706c792061206c6f6e6720737472696e67",
    "0x516b6fcd0f", "0xbf4f89001e670274dd", "0x572e4794", "0xecac89cad93923c02321", "0x10c8511e")

  for (hash <- hashes) {
    val b58: String = convertToBase58(hash)

    println(f"$hash%-56s -> $b58%-28s -> ${bytes2Hex(decode(b58))}%-56s" )
  }

}
