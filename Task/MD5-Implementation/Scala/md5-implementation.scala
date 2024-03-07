import java.lang.Math

object MD5 {
  private val INIT_A = 0x67452301
  private val INIT_B = 0xEFCDAB89
  private val INIT_C = 0x98BADCFE
  private val INIT_D = 0x10325476

  private val SHIFT_AMTS = Array(
    7, 12, 17, 22,
    5, 9, 14, 20,
    4, 11, 16, 23,
    6, 10, 15, 21
  )

  private val TABLE_T = Array.tabulate(64)(i => (Math.abs(Math.sin(i + 1)) * (1L << 32)).toLong.toInt)

  def computeMD5(message: Array[Byte]): Array[Byte] = {
    val messageLenBytes = message.length
    val numBlocks = ((messageLenBytes + 8) >>> 6) + 1
    val totalLen = numBlocks << 6
    val paddingBytes = Array.fill[Byte](totalLen - messageLenBytes)(0)
    paddingBytes(0) = 0x80.toByte

    var messageLenBits = messageLenBytes.toLong << 3
    for (i <- 0 until 8) {
      paddingBytes(paddingBytes.length - 8 + i) = messageLenBits.toByte
      messageLenBits >>>= 8
    }

    var a = INIT_A
    var b = INIT_B
    var c = INIT_C
    var d = INIT_D
    val buffer = new Array[Int](16)

    for (i <- 0 until numBlocks) {
      var index = i << 6
      for (j <- 0 until 64) {
        buffer(j >>> 2) = (((if (index < messageLenBytes) message(index) else paddingBytes(index - messageLenBytes)) << 24) | (buffer(j >>> 2) >>> 8)).toInt
        index += 1
      }
      val originalA = a
      val originalB = b
      val originalC = c
      val originalD = d

      for (j <- 0 until 64) {
        val div16 = j >>> 4
        val bufferIndex = j match {
          case j if j < 16 => j
          case j if j < 32 => (j * 5 + 1) & 0x0F
          case j if j < 48 => (j * 3 + 5) & 0x0F
          case j => (j * 7) & 0x0F
        }

        val f = div16 match {
          case 0 => (b & c) | (~b & d)
          case 1 => (b & d) | (c & ~d)
          case 2 => b ^ c ^ d
          case 3 => c ^ (b | ~d)
        }

        val temp = b + Integer.rotateLeft(a + f + buffer(bufferIndex) + TABLE_T(j), SHIFT_AMTS((div16 << 2) | (j & 3)))
        a = d
        d = c
        c = b
        b = temp
      }

      a += originalA
      b += originalB
      c += originalC
      d += originalD
    }

    val md5 = new Array[Byte](16)
    var count = 0
    for (i <- 0 until 4) {
      var n = i match {
        case 0 => a
        case 1 => b
        case 2 => c
        case 3 => d
      }
      for (j <- 0 until 4) {
        md5(count) = n.toByte
        n >>>= 8
        count += 1
      }
    }
    md5
  }

  def toHexString(b: Array[Byte]): String = b.map(byte => f"$byte%02X").mkString

  def main(args: Array[String]): Unit = {
    val testStrings = Array("", "a", "abc", "message digest", "abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", "12345678901234567890123456789012345678901234567890123456789012345678901234567890")
    testStrings.foreach { s =>
      println(s"0x${toHexString(computeMD5(s.getBytes))} <== \"$s\"")
    }
  }
}
