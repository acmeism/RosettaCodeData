import java.nio._

case class Hash(message: List[Byte]) {
  val defaultHashes = List(0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0)

  val hash = {
    val padded = generatePadding(message)
    val chunks: List[List[Byte]] = messageToChunks(padded)
    toHashForm(hashesFromChunks(chunks))
  }

  def generatePadding(message: List[Byte]): List[Byte] = {
    val finalPadding = BigInt(message.length * 8).toByteArray match {
      case x => List.fill(8 - x.length)(0.toByte) ++ x
    }
    val padding = (message.length + 1) % 64 match {
      case l if l < 56 =>
        message ::: 0x80.toByte :: List.fill(56 - l)(0.toByte)
      case l =>
        message ::: 0x80.toByte :: List.fill((64 - l) + 56 + 1)(0.toByte)
    }
    padding ::: finalPadding
  }

  def toBigEndian(bytes: List[Byte]) =
    ByteBuffer.wrap(bytes.toArray).getInt

  def messageToChunks(message: List[Byte]) =
    message.grouped(64).toList

  def chunkToWords(chunk: List[Byte]) =
    chunk.grouped(4).map(toBigEndian).toList

  def extendWords(words: List[Int]): List[Int] = words.length match {
    case i if i < 80 => extendWords(words :+ Integer.rotateLeft(
      (words(i - 3) ^ words(i - 8) ^ words(i - 14) ^ words(i - 16)), 1))
    case _ => words
  }

  def generateFK(i: Int, b: Int, c: Int, d: Int) = i match {
    case i if i < 20 => (b & c | ~b & d, 0x5A827999)
    case i if i < 40 => (b ^ c ^ d, 0x6ED9EBA1)
    case i if i < 60 => (b & c | b & d | c & d, 0x8F1BBCDC)
    case i if i < 80 => (b ^ c ^ d, 0xCA62C1D6)
  }

  def generateHash(words: List[Int], prevHash: List[Int]): List[Int] = {
    def generateHash(i: Int, currentHashes: List[Int]): List[Int] = i match {
      case i if i < 80 => currentHashes match {
        case a :: b :: c :: d :: e :: Nil => {
          val (f, k) = generateFK(i, b, c, d)
          val x = Integer.rotateLeft(a, 5) + f + e + k + words(i)
          val t = Integer.rotateLeft(b, 30)
          generateHash(i + 1, x :: a :: t :: c :: d :: Nil)
        }
      }
      case _ => currentHashes
    }
    addHashes(prevHash, generateHash(0, prevHash))
  }

  def addHashes(xs: List[Int], ys: List[Int]) = (xs, ys).zipped.map(_ + _)

  def hashesFromChunks(chunks: List[List[Byte]],
                        remainingHash: List[Int] = defaultHashes): List[Int] =
    chunks match {
      case Nil => remainingHash
      case x :: xs => {
        val words = extendWords(chunkToWords(x))
        val newHash = generateHash(words, remainingHash)
        hashesFromChunks(xs, newHash)
      }
    }

  def toHashForm(hashes: List[Int]) =
    hashes.map(b => ByteBuffer.allocate(4)
      .order(ByteOrder.BIG_ENDIAN).putInt(b).array.toList)
      .map(bytesToHex).mkString

  def bytesToHex(bytes: List[Byte]) =
    (for (byte <- bytes) yield (Character.forDigit((byte >> 4) & 0xF, 16) ::
      Character.forDigit((byte & 0xF), 16) :: Nil).mkString).mkString
}

object Hash extends App {
  def hash(message: String) = new Hash(message.getBytes.toList).hash

  println(hash("Rosetta Code"))
}
