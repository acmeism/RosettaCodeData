fun main() {
    val map = mapOf("hello" to 1, "world" to 2, "!" to 3)

    with(map) {
        forEach { println("key = ${it.key}, value = ${it.value}") }
        keys.forEach { println("key = $it") }
        values.forEach { println("value = $it") }
    }
}
