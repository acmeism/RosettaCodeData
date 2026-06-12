// version 1.1.2
// requires -ea JVM option

fun main(args: Array<String>) {
    assert(args.size > 0)  { "At least one command line argument must be passed to the program" }
    println("The following command line arguments have been passed:")
    for (arg in args) println(arg)
}
