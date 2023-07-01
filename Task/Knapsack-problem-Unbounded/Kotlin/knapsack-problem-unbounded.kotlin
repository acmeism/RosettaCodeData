// version 1.1.2

data class Item(val name: String, val value: Double, val weight: Double, val volume: Double)

val items = listOf(
    Item("panacea", 3000.0, 0.3, 0.025),
    Item("ichor", 1800.0, 0.2, 0.015),
    Item("gold", 2500.0, 2.0, 0.002)
)

val n = items.size
val count = IntArray(n)
val best  = IntArray(n)
var bestValue = 0.0

const val MAX_WEIGHT = 25.0
const val MAX_VOLUME = 0.25

fun knapsack(i: Int, value: Double, weight: Double, volume: Double) {
    if (i == n) {
        if (value > bestValue) {
            bestValue = value
            for (j in 0 until n) best[j] = count[j]
        }
        return
    }
    val m1 = Math.floor(weight / items[i].weight).toInt()
    val m2 = Math.floor(volume / items[i].volume).toInt()
    val m  = minOf(m1, m2)
    count[i] = m
    while (count[i] >= 0) {
        knapsack(
            i + 1,
            value  + count[i] * items[i].value,
            weight - count[i] * items[i].weight,
            volume - count[i] * items[i].volume
        )
        count[i]--
    }
}

fun main(args: Array<String>) {
    knapsack(0, 0.0, MAX_WEIGHT, MAX_VOLUME)
    println("Item Chosen  Number Value  Weight  Volume")
    println("-----------  ------ -----  ------  ------")
    var itemCount = 0
    var sumNumber = 0
    var sumWeight = 0.0
    var sumVolume = 0.0
    for (i in 0 until n) {
        if (best[i] == 0) continue
        itemCount++
        val name   = items[i].name
        val number = best[i]
        val value  = items[i].value  * number
        val weight = items[i].weight * number
        val volume = items[i].volume * number
        sumNumber += number
        sumWeight += weight
        sumVolume += volume
        print("${name.padEnd(11)}   ${"%2d".format(number)}    ${"%5.0f".format(value)}   ${"%4.1f".format(weight)}")
        println("    ${"%4.2f".format(volume)}")
    }
    println("-----------  ------ -----  ------  ------")
    print("${itemCount} items       ${"%2d".format(sumNumber)}    ${"%5.0f".format(bestValue)}   ${"%4.1f".format(sumWeight)}")
    println("    ${"%4.2f".format(sumVolume)}")
}
