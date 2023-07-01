object ScopeFunction extends App {
  val c = new C()
  val d = new D()
  val n = 1

  def a() = println("calling a")

  trait E {
    def m() = println("calling m")
  }

  a() // OK as a is internal
  B.f() // OK as f is public

  class C {
    // class level function visible everywhere, by default
    def g() = println("calling g")

    // class level function only visible within C and its subclasses
    protected def i() {
      println("calling i")
      println("calling h") // OK as h within same class
      // nested function in scope until end of i
      def j() = println("calling j")

      j()
    }

    // class level function only visible within C
    private def h() = println("calling h")
  }

  c.g() // OK as g is public but can't call h or i via c

  class D extends C with E {
    // class level function visible anywhere within the same module
    def k() {
      println("calling k")
      i() // OK as C.i is protected
      m() // OK as E.m is public and has a body
    }
  }

  d.k() // OK as k is public

  object B {
    // object level function visible everywhere, by default
    def f() = println("calling f")
  }

  val l = (i:Int, j: Int) => println(i,j)

  println("Good-bye!") // will be executed

}
