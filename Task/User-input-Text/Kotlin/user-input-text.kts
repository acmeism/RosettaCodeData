// version 1.1

fun main(args: Array<String>) {
    print("Enter a string : ")
    val s = readLine()!!
    println(s)
    do {
        print("Enter 75000 : ")
        val number = readLine()!!.toInt()
    } while (number != 75000)
}
