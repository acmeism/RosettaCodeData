// Kotlin JS Version 1.2.31

fun hello() {
    println("Hello")
}

fun main(args: Array<String>) {
    val code = js("_.hello.toString()")
    println(code)
}
