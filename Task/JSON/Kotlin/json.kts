// version 1.2.21

data class JsonObject(val foo: Int, val bar: Array<String>)

data class JsonObject2(val ocean: String, val blue: Array<Int>)

fun main(args: Array<String>) {
    // JSON to object
    val data: JsonObject = JSON.parse("""{ "foo": 1, "bar": ["10", "apples"] }""")
    println(JSON.stringify(data))

    // object to JSON
    val data2 = JsonObject2("water", arrayOf(1, 2))
    println(JSON.stringify(data2))
}
