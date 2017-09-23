// version 1.1.2

class SomeClass {
    val runtimeVariables = mutableMapOf<String, Any>()
}

fun main(args: Array<String>) {
    val sc = SomeClass()
    println("Create two variables at runtime: ")
    for (i in 1..2) {
        println("  Variable #$i:")
        print("       Enter name  : ")
        val name = readLine()!!
        print("       Enter value : ")
        val value = readLine()!!
        sc.runtimeVariables.put(name, value)
        println()
    }
    while (true) {
        print("Which variable do you want to inspect ? ")
        val name = readLine()!!
        val value = sc.runtimeVariables[name]
        if (value == null) {
            println("There is no variable of that name, try again")
        } else {
            println("Its value is '${sc.runtimeVariables[name]}'")
            return
        }
    }
}
