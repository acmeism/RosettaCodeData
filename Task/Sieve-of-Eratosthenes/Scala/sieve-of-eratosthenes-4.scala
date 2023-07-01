object Main extends App {
  import SoEwithArray._
  val top_num = 100000000
  val strt = System.nanoTime()
  val count = makeSoE_PrimesTo(top_num).size
  val end = System.nanoTime()
  println(s"Successfully completed without errors. [total ${(end - strt) / 1000000} ms]")
  println(f"Found $count primes up to $top_num" + ".")
  println("Using one large mutable Array and tail recursive loops.")
}
