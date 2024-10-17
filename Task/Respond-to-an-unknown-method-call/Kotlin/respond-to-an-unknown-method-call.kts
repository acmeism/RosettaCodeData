// Kotlin JS version 1.2.0 (Firefox 43)

class C {
    // this method prevents a TypeError being thrown if an unknown method is called
    fun __noSuchMethod__(id: String, args: Array<Any>) {
        println("Class C does not have a method called $id")
        if (args.size > 0) println("which takes arguments: ${args.asList()}")
    }
}

fun main(args: Array<String>) {
    val c: dynamic = C()  // 'dynamic' turns off compile time checks
    c.foo() // the compiler now allows this call even though foo() is undefined
}
