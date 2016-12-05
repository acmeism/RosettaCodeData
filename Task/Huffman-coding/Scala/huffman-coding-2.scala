// this version uses immutable data only, recursive functions and pattern matching
object Huffman {
  sealed trait Tree[+A]
  case class Leaf[A](value: A) extends Tree[A]
  case class Branch[A](left: Tree[A], right: Tree[A]) extends Tree[A]

  // recursively build the binary tree needed to Huffman encode the text
  def merge(xs: List[(Tree[Char], Int)]): List[(Tree[Char], Int)] = {
    if (xs.length == 1) xs else {
      val l = xs.head
      val r = xs.tail.head
      val merged = (Branch(l._1, r._1), l._2 + r._2)
      merge((merged :: xs.drop(2)).sortBy(_._2))
    }
  }

  // recursively search the branches of the tree for the required character
  def contains(tree: Tree[Char], char: Char): Boolean = tree match {
    case Leaf(c) => if (c == char) true else false
    case Branch(l, r) => contains(l, char) || contains(r, char)
  }

  // recursively build the path string required to traverse the tree to the required character
  def encodeChar(tree: Tree[Char], char: Char): String = {
    def go(tree: Tree[Char], char: Char, code: String): String = tree match {
      case Leaf(_) => code
      case Branch(l, r) => if (contains(l, char)) go(l, char, code + '0') else go(r, char, code + '1')
    }
    go(tree, char, "")
  }

  def main(args: Array[String]) {
    val text = "this is an example for huffman encoding"
    // transform the text into a list of tuples.
    // each tuple contains a Leaf node containing a unique character and an Int representing that character's weight
    val frequencies = text.groupBy(chars => chars).mapValues(group => group.length).toList.map(x => (Leaf(x._1), x._2)).sortBy(_._2)
    // build the Huffman Tree for this text
    val huffmanTree = merge(frequencies).head._1
    // output the resulting character codes
    println("Char\tWeight\tCode")
    frequencies.foreach(x => println(x._1.value + "\t" + x._2 + s"/${text.length}" + s"\t${encodeChar(huffmanTree, x._1.value)}"))
  }
}
