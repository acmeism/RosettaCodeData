class Example {
  private var _name: String = null

  def this(name: String) {
    this()
    _name = name
  }

  override def toString = "Hello, I am " + _name
}

object BreakPrivacy extends App {
  val foo: Example = new Example("Erik")
  for (f <- classOf[Example].getDeclaredFields
       if f.getName == "_name"
  ) {
    f.setAccessible(true)
    println(f.get(foo))
    f.set(foo, "Edith")
    println(foo)
  }
}
