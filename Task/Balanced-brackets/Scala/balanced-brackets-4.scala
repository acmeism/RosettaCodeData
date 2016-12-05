@scala.annotation.tailrec
final def isBalanced(
  str: List[Char],
  // accumulator|indicator|flag
  balance: Int = 0,
  options_Map: Map[Char, Int] = Map(('[' -> 1), (']' -> -1))
): Boolean = if (balance < 0) {
  // base case
  false
} else {
  if (str.isEmpty){
    // base case
    balance == 0
  } else {
    // recursive step
    isBalanced(str.tail, balance + options_Map(str.head))
  }
}
