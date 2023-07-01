package rosetta

import scala.annotation.tailrec

object MoveToFront {
  /**
   *  Default radix
   */
  private val R = 256

  /**
   *  Default symbol table
   */
  private def symbolTable = (0 until R).map(_.toChar).mkString

  /**
   *  Apply move-to-front encoding using default symbol table.
   */
  def encode(s: String): List[Int] = {
    encode(s, symbolTable)
  }

  /**
   *  Apply move-to-front encoding using symbol table <tt>symTable</tt>.
   */
  def encode(s: String, symTable: String): List[Int] = {
    val table = symTable.toCharArray

    @inline @tailrec def moveToFront(ch: Char, index: Int, tmpout: Char): Int = {
      val tmpin = table(index)
      table(index) = tmpout
      if (ch != tmpin)
        moveToFront(ch, index + 1, tmpin)
      else {
        table(0) = ch
        index
      }
    }

    @tailrec def encodeString(output: List[Int], s: List[Char]): List[Int] = s match {
      case Nil => output
      case x :: xs => {
        encodeString(moveToFront(x, 0, table(0)) :: output, s.tail)
      }
    }
    encodeString(Nil, s.toList).reverse
  }

  /**
   *  Apply move-to-front decoding using default symbol table.
   */
  def decode(ints: List[Int]): String = {
    decode(ints, symbolTable)
  }

  /**
   *  Apply move-to-front decoding using symbol table <tt>symTable</tt>.
   */
  def decode(lst: List[Int], symTable: String): String = {
    val table = symTable.toCharArray

    @inline def moveToFront(c: Char, index: Int) {
      for (i <- index-1 to 0 by -1)
        table(i+1) = table(i)
      table(0) = c
    }

    @tailrec def decodeList(output: List[Char], lst: List[Int]): List[Char] = lst match {
      case Nil => output
      case x :: xs => {
        val c = table(x)
        moveToFront(c, x)
        decodeList(c :: output, xs)
      }
    }
    decodeList(Nil, lst).reverse.mkString
  }

  def test(toEncode: String, symTable: String) {
		val encoded = encode(toEncode, symTable)
		println(toEncode + ": " + encoded)
		val decoded = decode(encoded, symTable)
		if (toEncode != decoded)
		  print("in")
		println("correctly decoded to " + decoded)
	}
}

/**
 * Unit tests the <tt>MoveToFront</tt> data type.
 */
object RosettaCodeMTF extends App {
	val symTable = "abcdefghijklmnopqrstuvwxyz"
	MoveToFront.test("broood", symTable)
	MoveToFront.test("bananaaa", symTable)
	MoveToFront.test("hiphophiphop", symTable)
}
