class Example {
  def foo(x: Int): Int = 42 + x
}

object Main extends App {
  val example = new Example

  val meth = example.getClass.getMethod("foo", classOf[Int])

  assert(meth.invoke(example, 5.asInstanceOf[AnyRef]) == 47.asInstanceOf[AnyRef], "Not confirm expectation.")
  println(s"Successfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")
}
