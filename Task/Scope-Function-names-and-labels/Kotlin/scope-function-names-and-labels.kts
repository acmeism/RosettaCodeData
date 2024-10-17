// version 1.1.2

// top level function visible anywhere within the current module
internal fun a() = println("calling a")

object B {
    // object level function visible everywhere, by default
    fun f() = println("calling f")
}

open class C {
    // class level function visible everywhere, by default
    fun g() = println("calling g")

    // class level function only visible within C
    private fun h() = println("calling h")

    // class level function only visible within C and its subclasses
    protected fun i() {
        println("calling i")
        println("calling h")  // OK as h within same class
        // nested function in scope until end of i
        fun j() = println("calling j")
        j()
    }
}

class D : C(), E {
    // class level function visible anywhere within the same module
    fun k() {
        println("calling k")
        i()  // OK as C.i is protected
        m()  // OK as E.m is public and has a body
    }
}

interface E {
    fun m() {
        println("calling m")
    }
}

fun main(args: Array<String>) {
    a()    // OK as a is internal
    B.f()  // OK as f is public
    val c = C()
    c.g()  // OK as g is public but can't call h or i via c
    val d = D()
    d.k()  // OK as k is public
    // labelled lambda expression assigned to variable 'l'
    val l = lambda@ { ->
        outer@ for (i in 1..3) {
            for (j in 1..3) {
                if (i == 3) break@outer    // jumps out of outer loop
                if (j == 2) continue@outer // continues with next iteration of outer loop
                println ("i = $i, j = $j")
            }
            if (i > 1) println ("i = $i")  // never executed
        }
        val n = 1
        if (n == 1) return@lambda  // returns from lambda
        println("n = $n")  // never executed
    }
    l()  // invokes lambda
    println("Good-bye!")   // will be executed
}
