// version 1.1.4

fun main(args: Array<String>) {
    var n: Int
    do {
        print("How many integer variables do you want to create (max 5) : ")
        n = readLine()!!.toInt()
    }
    while (n < 1 || n > 5)

    val map = mutableMapOf<String, Int>()
    var name: String
    var value: Int
    var i = 1
    println("OK, enter the variable names and their values, below")
    do {
        println("\n  Variable $i")
        print("    Name  : ")
        name = readLine()!!
        if (map.containsKey(name)) {
            println("  Sorry, you've already created a variable of that name, try again")
            continue
        }
        print("    Value : ")
        value = readLine()!!.toInt()
        map.put(name, value)
        i++
    }
    while (i <= n)

    println("\nEnter q to quit")
    var v: Int?
    while (true) {
        print("\nWhich variable do you want to inspect : ")
        name = readLine()!!
        if (name.toLowerCase() == "q") return
        v = map[name]
        if (v == null) println("Sorry there's no variable of that name, try again")
        else println("It's value is $v")
    }
}
