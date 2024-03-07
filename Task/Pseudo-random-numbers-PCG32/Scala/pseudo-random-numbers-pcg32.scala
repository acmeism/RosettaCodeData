object PCG32 {
  private val N = 6364136223846793005L

  private var state = 0x853c49e6748fea9bL
  private var inc = 0xda3e39cb94b95bdbL

  def seed(seedState: Long, seedSequence: Long): Unit = {
    state = 0
    inc = (seedSequence << 1) | 1
    nextInt()
    state += seedState
    nextInt()
  }

  def nextInt(): Int = {
    val old = state
    state = old * N + inc
    val shifted = (((old >>> 18) ^ old) >>> 27).toInt
    val rot = (old >>> 59).toInt
    (shifted >>> rot) | (shifted << ((~rot + 1) & 31))
  }

  def nextFloat(): Double = {
    val u = nextInt() & 0xffffffffL
    u.toDouble / (1L << 32)
  }
}

object Main extends App {
  val r = PCG32

  r.seed(42, 54)
  println(Integer.toUnsignedString(r.nextInt()))
  println(Integer.toUnsignedString(r.nextInt()))
  println(Integer.toUnsignedString(r.nextInt()))
  println(Integer.toUnsignedString(r.nextInt()))
  println(Integer.toUnsignedString(r.nextInt()))
  println()

  val counts = Array(0, 0, 0, 0, 0)
  r.seed(987654321, 1)
  for (_ <- 1 to 100000) {
    val j = Math.floor(r.nextFloat() * 5.0).toInt
    counts(j) += 1
  }

  println("The counts for 100,000 repetitions are:")
  for (i <- counts.indices) {
    println(s"  $i : ${counts(i)}")
  }
}
