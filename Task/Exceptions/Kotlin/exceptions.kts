// version 1.0.6

// In Kotlin all Exception classes derive from Throwable and, by convention, end with the word 'Exception'
class MyException (override val message: String?): Throwable(message)

fun foo() {
    throw MyException("Bad foo!")
}

fun goo() {
    try {
        foo()
    }
    catch (me: MyException) {
        println("Caught MyException due to '${me.message}'")
        println("\nThe stack trace is:\n")
        me.printStackTrace()
    }
}

fun main(args: Array<String>) {
    goo()
}
