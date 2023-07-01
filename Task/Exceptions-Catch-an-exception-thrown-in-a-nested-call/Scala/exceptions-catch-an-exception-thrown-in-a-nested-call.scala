object ExceptionsTest extends App {
  class U0 extends Exception
  class U1 extends Exception

  def foo {
    for (i <- 0 to 1)
      try {
        bar(i)
      } catch { case e: U0 => println("Function foo caught exception U0") }
  }

  def bar(i: Int) {
    def baz(i: Int) = { if (i == 0) throw new U0 else throw new U1 }

    baz(i) // Nest those calls
  }

  foo
}
