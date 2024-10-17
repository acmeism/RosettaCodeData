// version 1.1.2

class SomeClass

class SomeOtherClass {
    lateinit var sc: SomeClass

    fun initialize() {
        sc = SomeClass()  // not initialized in place or in constructor
    }

    fun printSomething() {
        println(sc)  // 'sc' may not have been initialized at this point
    }

    fun someFunc(): String {
        // for now calls a library function which throws an error and returns Nothing
        TODO("someFunc not yet implemented")
    }
}

fun main(args: Array<String>) {
    val soc = SomeOtherClass()

    try {
        soc.printSomething()
    }
    catch (ex: Exception) {
        println(ex)
    }

    try {
        soc.someFunc()
    }
    catch (e: Error) {
        println(e)
    }
}
