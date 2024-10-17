// version 1.1.0

fun main(args: Array<String>) {
    val names = arrayOf("Jimmy", "Bill", "Barack", "Donald")
    val ages  = arrayOf(92, 70, 55, 70)
    val hash  = mapOf(*names.zip(ages).toTypedArray())
    hash.forEach { println("${it.key.padEnd(6)} aged ${it.value}") }
}
