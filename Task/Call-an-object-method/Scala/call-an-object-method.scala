/** This class implicitly includes a constructor which accepts an Int and
 *  creates "val variable1: Int" with that value.
 */
class MyClass(val variable1: Int) {
  var variable2 = "asdf" // Another instance variable; a public var this time
  def this() = this(0) // An auxilliary constructor that instantiates with a default value
  def myMethod = variable1 // A getter for variable1, getter of variable1 is auto-created
}

object HelloObject {
  val s = "Hello" // Not private, so getter auto-generated
}

/** Demonstrate use of our example class.
 */
object Call_an_object_method extends Application {
  val s = "Hello"
  val m = new MyClass()
  val n = new MyClass(3)

  println(HelloObject.s) // prints "Hello" by object getterHelloObject

  println(m.myMethod) // prints 0
  println(n.myMethod) // prints 3
}
