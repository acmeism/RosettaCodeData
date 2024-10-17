// version 1.1.2

data class Item(val name: String, val weight: Int, val value: Int, val count: Int)

val items = listOf(
    Item("map", 9, 150, 1),
    Item("compass", 13, 35, 1),
    Item("water", 153, 200, 2),
    Item("sandwich", 50, 60, 2),
    Item("glucose", 15, 60, 2),
    Item("tin", 68, 45, 3),
    Item("banana", 27, 60, 3),
    Item("apple", 39, 40, 3),
    Item("cheese", 23, 30, 1),
    Item("beer", 52, 10, 3),
    Item("suntan cream", 11, 70, 1),
    Item("camera", 32, 30, 1),
    Item("T-shirt", 24, 15, 2),
    Item("trousers", 48, 10, 2),
    Item("umbrella", 73, 40, 1),
    Item("waterproof trousers", 42, 70, 1),
    Item("waterproof overclothes", 43, 75, 1),
    Item("note-case", 22, 80, 1),
    Item("sunglasses", 7, 20, 1),
    Item("towel", 18, 12, 2),
    Item("socks", 4, 50, 1),
    Item("book", 30, 10, 2)
)

val n = items.size

const val MAX_WEIGHT = 400

fun knapsack(w: Int): IntArray {
    val m  = Array(n + 1) { IntArray(w + 1) }
    for (i in 1..n) {
        for (j in 0..w) {
            m[i][j] = m[i - 1][j]
            for (k in 1..items[i - 1].count) {
                if (k * items[i - 1].weight > j) break
                val v = m[i - 1][j - k * items[i - 1].weight] + k * items[i - 1].value
                if (v > m[i][j]) m[i][j] = v
            }
        }
    }
    val s = IntArray(n)
    var j = w
    for (i in n downTo 1) {
        val v = m[i][j]
        var k = 0
        while (v != m[i - 1][j] + k * items[i - 1].value) {
            s[i - 1]++
            j -= items[i - 1].weight
            k++
        }
    }
    return s
}

fun main(args: Array<String>) {
   val s = knapsack(MAX_WEIGHT)
   println("Item Chosen             Weight Value  Number")
   println("---------------------   ------ -----  ------")
   var itemCount = 0
   var sumWeight = 0
   var sumValue  = 0
   var sumNumber = 0
   for (i in 0 until n) {
       if (s[i] == 0) continue
       itemCount++
       val name   = items[i].name
       val number = s[i]
       val weight = items[i].weight * number
       val value  = items[i].value  * number
       sumNumber += number
       sumWeight += weight
       sumValue  += value
       println("${name.padEnd(22)}    ${"%3d".format(weight)}   ${"%4d".format(value)}    ${"%2d".format(number)}")
   }
   println("---------------------   ------ -----  ------")
   println("Items chosen $itemCount           ${"%3d".format(sumWeight)}   ${"%4d".format(sumValue)}    ${"%2d".format(sumNumber)}")
}
