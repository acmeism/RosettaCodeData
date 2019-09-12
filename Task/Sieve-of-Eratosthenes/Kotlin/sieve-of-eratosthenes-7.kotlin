data class CIS<T>(val head: T, val tailf: () -> CIS<T>) {
  fun toSequence() = generateSequence(this) { it.tailf() } .map { it.head }
}

fun primes(): Sequence<Int> {
  fun merge(a: CIS<Int>, b: CIS<Int>): CIS<Int> {
    val ahd = a.head; val bhd = b.head
    if (ahd > bhd) return CIS(bhd) { ->merge(a, b.tailf()) }
    if (ahd < bhd) return CIS(ahd) { ->merge(a.tailf(), b) }
    return CIS(ahd) { ->merge(a.tailf(), b.tailf()) }
  }
  fun bpmults(p: Int): CIS<Int> {
    val inc = p + p
    fun mlts(c: Int): CIS<Int> = CIS(c) { ->mlts(c + inc) }
    return mlts(p * p)
  }
  fun allmults(ps: CIS<Int>): CIS<CIS<Int>> = CIS(bpmults(ps.head)) { allmults(ps.tailf()) }
  fun pairs(css: CIS<CIS<Int>>): CIS<CIS<Int>> {
    val xs = css.head; val yss = css.tailf(); val ys = yss.head
    return CIS(merge(xs, ys)) { ->pairs(yss.tailf()) }
  }
  fun union(css: CIS<CIS<Int>>): CIS<Int> {
    val xs = css.head
    return CIS(xs.head) { -> merge(xs.tailf(), union(pairs(css.tailf()))) }
  }
  tailrec fun minus(n: Int, cs: CIS<Int>): CIS<Int> =
    if (n >= cs.head) minus(n + 2, cs.tailf()) else CIS(n) { ->minus(n + 2, cs) }
  fun oddprms(): CIS<Int> = CIS(3) { -> CIS(5) { ->minus(7, union(allmults(oddprms()))) } }
  return CIS(2) { ->oddprms() } .toSequence()
}

fun main(args: Array<String>) {
  val limit = 1000000
  val strt = System.currentTimeMillis()
  println(primes().takeWhile { it <= limit } .count())
  val stop = System.currentTimeMillis()
  println("Took ${stop - strt} milliseconds.")
}
