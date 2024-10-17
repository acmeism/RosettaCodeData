// version 1.0.6

class U0 : Throwable("U0 occurred")
class U1 : Throwable("U1 occurred")

fun foo() {
    for (i in 1..2) {
        try {
            bar(i)
        } catch(e: U0) {
            println(e.message)
        }
    }
}

fun bar(i: Int) {
    baz(i)
}

fun baz(i: Int) {
    when (i) {
        1 -> throw U0()
        2 -> throw U1()
    }
}

fun main(args: Array<String>) {
    foo()
}
