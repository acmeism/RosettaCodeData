fun main(args: Array<String>) {
    // map definition:
    val map = mapOf("foo" to 5,
                    "bar" to 10,
                    "baz" to 15,
                    "foo" to 6)

    // retrieval:
    println(map["foo"]) // => 6
    println(map["invalid"]) // => null

    // check keys:
    println("foo" in map) // => true
    println("invalid" in map) // => false

    // iterate over keys:
    for (k in map.keys) print("$k ")
    println()

    // iterate over values:
    for (v in map.values) print("$v ")
    println()

    // iterate over key, value pairs:
    for ((k, v) in map) println("$k => $v")
}
