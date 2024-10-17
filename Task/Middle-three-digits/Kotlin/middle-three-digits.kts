fun middleThree(x: Int): Int? {
    val s = Math.abs(x).toString()
    return when {
        s.length < 3 -> null // throw Exception("too short!")
        s.length % 2 == 0 -> null // throw Exception("even number of digits")
        else -> ((s.length / 2) - 1).let { s.substring(it, it + 3) }.toInt()
    }
}

fun main(args: Array<String>) {
    println(middleThree(12345)) // 234
    println(middleThree(1234)) // null
    println(middleThree(1234567)) // 345
    println(middleThree(123))// 123
    println(middleThree(123555)) //null
}
