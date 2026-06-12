// version 1.0.6
fun showType(a: Any) = when (a) {
        is Int    -> println("'$a' is an integer")
        is Double -> println("'$a' is a double")
        is Char   -> println("'$a' is a character")
        else      -> println("'$a' is some other type")
    }

fun main(args: Array<String>) {
    showType(5)
    showType(7.5)
    showType('d')
    showType(true)
}
