// version 1.0.6

interface MyInterface {
    fun foo()                     // no arguments, no return type
    fun goo(i: Int, j: Int)       // two arguments, no return type
    fun voo(vararg v: Int)        // variable number of arguments, no return type
    fun ooo(o: Int = 1): Int      // optional argument with default value and return type Int
    fun roo(): Int                // no arguments with return type Int
    val poo: Int                // read only property of type Int
}

abstract class MyAbstractClass {
    abstract fun afoo()           // abstract member function, no arguments or return type
    abstract var apoo: Int        // abstract read/write member property of type Int
}

class Derived : MyAbstractClass(), MyInterface {
    override fun afoo() {}
    override var apoo: Int = 0

    override fun foo() {}
    override fun goo(i: Int, j: Int) {}
    override fun voo(vararg v: Int) {}
    override fun ooo(o: Int): Int = o  // can't specify default argument again here but same as in interface
    override fun roo(): Int = 2
    override val poo: Int = 3
}

fun main(args: Array<String>) {
    val d = Derived()
    println(d.apoo)
    println(d.ooo())  // default argument of 1 inferred
    println(d.roo())
    println(d.poo)
}
