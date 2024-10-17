// version 1.1.2

fun main(args: Array<String>) {
    for(i in 1 .. 10) {
        if (i % 5 == 0) {
            println(i)
            continue
        }
        print("$i, ")
    }
}
