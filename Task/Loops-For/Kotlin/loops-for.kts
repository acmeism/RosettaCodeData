fun main(args: Array<String>) {
    (1..5).forEach {
        (1..it).forEach { print('*') }
        println()
    }
}
