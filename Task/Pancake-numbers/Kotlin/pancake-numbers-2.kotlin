data class PancakeResult(val example: List<Int>, val depth: Int)

fun pancake(n: Int): PancakeResult {
  fun List<Int>.copyFlip(spatula: Int) = toMutableList().apply { subList(0, spatula).reverse() }
  val initialStack = List(n) { it + 1 }
  val stackFlips = mutableMapOf(initialStack to 1)
  val queue = ArrayDeque(listOf(initialStack))
  while (queue.isNotEmpty()) {
    val stack = queue.removeFirst()
    val flips = stackFlips[stack]!! + 1
    for (spatula in 2 .. n) {
      val flipped = stack.copyFlip(spatula)
      if (stackFlips.putIfAbsent(flipped, flips) == null) {
        queue.addLast(flipped)
      }
    }
  }
  return stackFlips.maxByOrNull { it.value }!!.run { PancakeResult(key, value) }
}

fun main() {
  for (i in 1 .. 10) {
    with (pancake(i)) { println("pancake($i) = $depth. Example: $example") }
  }
}
