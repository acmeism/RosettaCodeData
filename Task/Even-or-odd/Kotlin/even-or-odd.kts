// version 1.0.5-2

fun main(args: Array<String>) {
    while (true) {
        print("Enter an integer or 0 to finish : ")
        val n = readLine()!!.toInt()
        when {
            n == 0     -> return
            n % 2 == 0 -> println("Your number is even")
            else       -> println("Your number is odd")
        }
    }
}
