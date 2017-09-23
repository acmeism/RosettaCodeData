// version 1.1.2

fun recurse(i: Int) {
    try {
        recurse(i + 1)
    }
    catch(e: StackOverflowError) {
        println("Limit of recursion is $i")
    }
}

fun main(args: Array<String>) = recurse(0)
