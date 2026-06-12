import scala.util.control.Breaks._

object BaconCipher {
  private val CODES = Map(
    'a' -> "AAAAA", 'b' -> "AAAAB", 'c' -> "AAABA", 'd' -> "AAABB", 'e' -> "AABAA",
    'f' -> "AABAB", 'g' -> "AABBA", 'h' -> "AABBB", 'i' -> "ABAAA", 'j' -> "ABAAB",
    'k' -> "ABABA", 'l' -> "ABABB", 'm' -> "ABBAA", 'n' -> "ABBAB", 'o' -> "ABBBA",
    'p' -> "ABBBB", 'q' -> "BAAAA", 'r' -> "BAAAB", 's' -> "BAABA", 't' -> "BAABB",
    'u' -> "BABAA", 'v' -> "BABAB", 'w' -> "BABBA", 'x' -> "BABBB", 'y' -> "BBAAA",
    'z' -> "BBAAB", ' ' -> "BBBAA" // use ' ' to denote any non-letter
  )

  def encode(plainText: String, message: String): String = {
    val sb = new StringBuilder

    val pt = plainText.toLowerCase()
    for (c <- pt.toCharArray) {
      if ('a' <= c && c <= 'z') {
        sb.append(CODES(c))
      } else {
        sb.append(CODES(' '))
      }
    }
    val et = sb.toString()

    var count = 0

    val mg = message.toLowerCase()
    sb.setLength(0)

    breakable {
      for (c <- mg.toArray) {
        if ('a' <= c && c <= 'z') {
          if ('A' == et(count)) {
            sb.append(c)
          } else {
            sb.append(c.toUpper)
          }
          count = count + 1
          if (count == et.length) {
            break()
          }
        } else {
          sb.append(c)
        }
      }
    }

    sb.toString
  }

  def decode(message: String): String = {
    val sb = new StringBuilder
    for (c <- message.toCharArray) {
      if ('a' <= c && c <= 'z') {
        sb.append('A')
      }
      if ('A' <= c && c <= 'Z') {
        sb.append('B')
      }
    }
    val et = sb.toString()
    sb.setLength(0)

    val default = ('@', "")
    for (g <- et.toCharArray.grouped(5)) {
      val q = new String(g)
      val key = CODES.find(_._2 == q).getOrElse(default)._1
      sb.append(key)
    }

    sb.toString()
  }

  def main(args: Array[String]): Unit = {
    val plainText = "the quick brown fox jumps over the lazy dog"
    val message = "bacon's cipher is a method of steganography created by francis bacon. " +
      "this task is to implement a program for encryption and decryption of " +
      "plaintext using the simple alphabet of the baconian cipher or some " +
      "other kind of representation of this alphabet (make anything signify anything). " +
      "the baconian alphabet may optionally be extended to encode all lower " +
      "case characters individually and/or adding a few punctuation characters " +
      "such as the space."
    val cipherText = encode(plainText, message)
    println(s"Cipher text ->\n\n$cipherText")
    val decodedText = decode(cipherText)
    println(s"Hidden text ->\n\n$decodedText")
  }
}
