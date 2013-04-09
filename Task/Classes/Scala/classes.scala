/**
 * This class implicitly includes a constructor which accepts an int and
 * creates "val variable1: Int" with that value.
 */
class MyClass(variable1: Int) {
    var variable2 = "asdf" // Another instance variable; a var this time
    def this() = this(0) // An auxilliary constructor that instantiates with a default value
    def myMethod = variable1 // A getter for variable1
}

/**
 * Demonstrate use of our example class.
 */
object Main extends Application {
    val m = new MyClass()
    val n = new MyClass(3)
    println(m.myMethod) // prints 0
    println(n.myMethod) // prints 3
}
