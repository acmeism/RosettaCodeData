// version 1.0.6

fun main(args: Array<String>) {
    // conventional 'if/else if/else' statement
    if (args.isEmpty()) println("No arguments were supplied")
    else if (args.size == 1) println("One argument was supplied")
    else println("${args.size} arguments were supplied")

    print("Enter an integer : ")
    val i = readLine()!!.toInt()

    // 'when' statement (similar to 'switch' in C family languages)
    when (i) {
        0, 1      -> println("0 or 1")
        in 2 .. 9 -> println("Between 2 and 9")
        else      -> println("Out of range")
    }

    // both of these can be used as expressions as well as statements
    val s = if (i < 0) "negative" else "non-negative"
    println("$i is $s")
    val t = when {
        i > 0  -> "positive"
        i == 0 -> "zero"
        else   -> "negative"
    }
    println("$i is $t")
}
