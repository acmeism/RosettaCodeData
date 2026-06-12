// version 1.0.6

fun <T> sattolo(items: Array<T>) {
    for (i in items.size - 1 downTo 1) {
        val j = (Math.random() * i).toInt()
        val t = items[i]
        items[i] = items[j]
        items[j] = t
    }
}

fun main(args: Array<String>) {
    val items = arrayOf(11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22)
    println(items.joinToString())
    sattolo(items)
    println(items.joinToString())
}
