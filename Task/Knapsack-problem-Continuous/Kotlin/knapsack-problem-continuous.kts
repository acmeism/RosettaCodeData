// version 1.1.2

data class Item(val name: String, val weight: Double, val value: Double)

val items = mutableListOf(
    Item("beef", 3.8, 36.0),
    Item("pork", 5.4, 43.0),
    Item("ham", 3.6, 90.0),
    Item("greaves", 2.4, 45.0),
    Item("flitch", 4.0, 30.0),
    Item("brawn", 2.5, 56.0),
    Item("welt", 3.7, 67.0),
    Item("salami", 3.0, 95.0),
    Item("sausage", 5.9, 98.0)
)

const val MAX_WEIGHT = 15.0

fun main(args: Array<String>) {
    // sort items by value per unit weight in descending order
    items.sortByDescending { it.value / it.weight }
    println("Item Chosen   Weight  Value  Percentage")
    println("-----------   ------ ------  ----------")
    var w = MAX_WEIGHT
    var itemCount = 0
    var sumValue = 0.0
    for (item in items) {
        itemCount++
        if (item.weight <= w) {
           sumValue += item.value
           print("${item.name.padEnd(11)}     ${"%3.1f".format(item.weight)}   ${"%5.2f".format(item.value)}")
           println("    100.00")
        }
        else {
           val value  = Math.round((w / item.weight * item.value * 100.0)) / 100.0
           val percentage = Math.round((w / item.weight * 10000.0)) / 100.0
           sumValue += value
           print("${item.name.padEnd(11)}     ${"%3.1f".format(w)}   ${"%5.2f".format(value)}")
           println("     $percentage")
           break
        }
        w -= item.weight
        if (w == 0.0) break
    }
    println("-----------   ------ ------")
    println("${itemCount} items        15.0  ${"%6.2f".format(sumValue)}")
}
