object CycleDetection extends App {

  def brent(f: Int => Int, x0: Int): (Int, Int) = {
    // main phase: search successive powers of two
    // f(x0) is the element/node next to x0.
    var (power, λ, μ, tortoise, hare) = (1, 1, 0, x0, f(x0))

    while (tortoise != hare) {
      if (power == λ) { // time to start a new power of two?
        tortoise = hare
        power *= 2
        λ = 0
      }
      hare = f(hare)
      λ += 1
    }

    // Find the position of the first repetition of length 'λ'
    tortoise = x0
    hare = x0
    for (i <- 0 until λ) hare = f(hare)

    // The distance between the hare and tortoise is now 'λ'.
    // Next, the hare and tortoise move at same speed until they agree
    while (tortoise != hare) {
      tortoise = f(tortoise)
      hare = f(hare)
      μ += 1
    }
    (λ, μ)
  }

  def cycle = loop.slice(μ, μ + λ)

  def f = (x: Int) => (x * x + 1) % 255

  // Generator for the first terms of the sequence starting from 3
  def loop: LazyList[Int] = 3 #:: loop.map(f(_))

  val (λ, μ) = brent(f, 3)
  println(s"Cycle length = $λ")
  println(s"Start index  = $μ")
  println(s"Cycle        = ${cycle.force}")

}
