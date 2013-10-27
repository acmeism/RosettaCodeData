object StackTest extends App {

  val stack = new Stack[String]

  stack.push("Peter Pan")
  stack.push("Suske & Wiske", "Alice in Wonderland")

  assert(stack.peek == "Alice in Wonderland")
  assert(stack.pop() == "Alice in Wonderland")
  assert(stack.pop() == "Suske & Wiske")
  assert(stack.pop() == "Peter Pan")
  println("Completed without errors")
}
