// version 1.0.5-2

fun main(args: Array<String>) {
    val r = Regex("""-?\d+[ ]+-?\d+""")
    while(true) {
        print("Enter two integers separated by space(s) or q to quit: ")
        val input: String = readLine()!!.trim()
        if (input == "q" || input == "Q") break
        if (!input.matches(r)) {
            println("Invalid input, try again")
            continue
        }
        val index = input.lastIndexOf(' ')
        val a = input.substring(0, index).trimEnd().toInt()
        val b = input.substring(index + 1).toInt()
        if (Math.abs(a) > 1000 || Math.abs(b) > 1000) {
            println("Both numbers must be in the interval [-1000, 1000] - try again")
        }
        else {
            println("Their sum is ${a + b}\n")
        }
    }
}
