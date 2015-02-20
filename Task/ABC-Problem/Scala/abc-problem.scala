object AbcBlocks extends App {

  protected class Block(face1: Char, face2: Char) {

    def isFacedWith(that: Char) = { that == face1 || that == face2 }
    override def toString() = face1.toString + face2
  }
  protected object Block {
    def apply(faces: String) = new Block(faces.head, faces.last)
  }

  type word = Seq[Block]

  private val blocks = List(Block("BO"), Block("XK"), Block("DQ"), Block("CP"), Block("NA"),
    Block("GT"), Block("RE"), Block("TG"), Block("QD"), Block("FS"),
    Block("JW"), Block("HU"), Block("VI"), Block("AN"), Block("OB"),
    Block("ER"), Block("FS"), Block("LY"), Block("PC"), Block("ZM"))

  private def isMakeable(word: String, blocks: word) = {

    def getTheBlocks(word: String, blocks: word) = {

      def inner(word: String, toCompare: word, rest: word, accu: word): word = {
        if (word.isEmpty || rest.isEmpty || toCompare.isEmpty) accu
        else if (toCompare.head.isFacedWith(word.head)) {
          val restant = rest diff List(toCompare.head)
          inner(word.tail, restant, restant, accu :+ toCompare.head)
        } else inner(word, toCompare.tail, rest, accu)
      }
      inner(word, blocks, blocks, Nil)
    }

    word.lengthCompare(getTheBlocks(word, blocks).size) == 0
  }

  val words = List("A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSED", "ANBOCPDQERSFTGUVWXLZ")
  // Automatic tests
  assert(isMakeable(words(0), blocks))
  assert(isMakeable(words(1), blocks))
  assert(!isMakeable(words(2), blocks)) // BOOK not
  assert(isMakeable(words(3), blocks))
  assert(!isMakeable(words(4), blocks)) // COMMON not
  assert(isMakeable(words(5), blocks))
  assert(isMakeable(words(6), blocks))
  assert(isMakeable(words(7), blocks))

  //words(7).mkString.permutations.foreach(s => assert(isMakeable(s, blocks)))

  words.foreach(w => println(s"$w can${if (isMakeable(w, blocks)) " " else "not "}be made."))
}
