class Example(private var name: String) {
  override def toString = s"Hello, I am $name"
}

object BreakPrivacy extends App {
  val field = classOf[Example].getDeclaredField("name")
  field.setAccessible(true)

  val foo = new Example("Erik")
  println(field.get(foo))
  field.set(foo, "Edith")
  println(foo)
}
