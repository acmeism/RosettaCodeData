// version 1.0.6

fun main(args: Array<String>) {
    print("Enter number of milliseconds to sleep: ")
    val ms = readLine()!!.toLong()
    println("Sleeping...")
    Thread.sleep(ms)
    println("Awake!")
}
