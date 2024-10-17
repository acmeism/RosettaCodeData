// version 1.1.2

enum class Trit {
    TRUE, MAYBE, FALSE;

    operator fun not() = when (this) {
        TRUE  -> FALSE
        MAYBE -> MAYBE
        FALSE -> TRUE
    }

    infix fun and(other: Trit) = when (this) {
        TRUE  -> other
        MAYBE -> if (other == FALSE) FALSE else MAYBE
        FALSE -> FALSE
    }

    infix fun or(other: Trit) = when (this) {
        TRUE  -> TRUE
        MAYBE -> if (other == TRUE) TRUE else MAYBE
        FALSE -> other
    }

    infix fun imp(other: Trit) = when (this) {
        TRUE  -> other
        MAYBE -> if (other == TRUE) TRUE else MAYBE
        FALSE -> TRUE
    }

    infix fun eqv(other: Trit) = when (this) {
        TRUE  -> other
        MAYBE -> MAYBE
        FALSE -> !other
    }

    override fun toString() = this.name[0].toString()
}

fun main(args: Array<String>) {
    val ta = arrayOf(Trit.TRUE, Trit.MAYBE, Trit.FALSE)

    // not
    println("not")
    println("-------")
    for (t in ta) println(" $t  | ${!t}")
    println()

    // and
    println("and | T  M  F")
    println("-------------")
    for (t in ta) {
        print(" $t  | ")
        for (tt in ta) print("${t and tt}  ")
        println()
    }
    println()

    // or
    println("or  | T  M  F")
    println("-------------")
    for (t in ta) {
        print(" $t  | ")
        for (tt in ta) print("${t or tt}  ")
        println()
    }
    println()

    // imp
    println("imp | T  M  F")
    println("-------------")
    for (t in ta) {
        print(" $t  | ")
        for (tt in ta) print("${t imp tt}  ")
        println()
    }
    println()

    // eqv
    println("eqv | T  M  F")
    println("-------------")
    for (t in ta) {
        print(" $t  | ")
        for (tt in ta) print("${t eqv tt}  ")
        println()
    }
}
