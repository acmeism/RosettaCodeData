// version 1.0.6

data class IfBoth(val cond1: Boolean, val cond2: Boolean) {
    fun elseFirst(func: () -> Unit): IfBoth {
        if (cond1 && !cond2) func()
        return this
    }

    fun elseSecond(func: () -> Unit): IfBoth {
        if (cond2 && !cond1) func()
        return this
    }

    fun elseNeither(func: () -> Unit): IfBoth {
        if (!cond1 && !cond2) func()
        return this  // in case it's called out of order
    }
}

fun ifBoth(cond1: Boolean, cond2: Boolean, func: () -> Unit): IfBoth {
    if (cond1 && cond2) func()
    return IfBoth(cond1, cond2)
}

fun main(args: Array<String>) {
    var a = 0
    var b = 1
    ifBoth (a == 1, b == 3) {
        println("a = 1 and b = 3")
    }
    .elseFirst {
        println("a = 1 and b <> 3")
    }
    .elseSecond {
        println("a <> 1 and b = 3")
    }
    .elseNeither {
        println("a <> 1 and b <> 3")
    }

    // It's also possible to omit any (or all) of the 'else' clauses or to call them out of order
    a = 1
    b = 0
    ifBoth (a == 1, b == 3) {
        println("a = 1 and b = 3")
    }
    .elseNeither {
        println("a <> 1 and b <> 3")
    }
    .elseFirst {
        println("a = 1 and b <> 3")
    }
}
