// version 1.0.6

fun someFunction(first: String, second: Int = 2, third: Double) {
    println("First = ${first.padEnd(10)}, Second = $second, Third = $third")
}

fun main(args: Array<String>) {
    // using positional parameters
    someFunction("positional", 1, 2.0)

    // using named parameters
    someFunction(first = "named", second = 1, third = 2.0)

    // omitting 2nd parameter which is optional because it has a default value
    someFunction(first = "omitted", third = 2.0)

    // using first and third parameters in reverse
    someFunction(third = 2.0, first = "reversed")
}
