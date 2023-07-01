// version 1.1.2

data class Item(val name: String, val weight: Int, val value: Int)

val wants = listOf(
    Item("map", 9, 150),
    Item("compass", 13, 35),
    Item("water", 153, 200),
    Item("sandwich", 50, 160),
    Item("glucose", 15, 60),
    Item("tin", 68, 45),
    Item("banana", 27, 60),
    Item("apple", 39, 40),
    Item("cheese", 23, 30),
    Item("beer", 52, 10),
    Item("suntan cream", 11, 70),
    Item("camera", 32, 30),
    Item("T-shirt", 24, 15),
    Item("trousers", 48, 10),
    Item("umbrella", 73, 40),
    Item("waterproof trousers", 42, 70),
    Item("waterproof overclothes", 43, 75),
    Item("note-case", 22, 80),
    Item("sunglasses", 7, 20),
    Item("towel", 18, 12),
    Item("socks", 4, 50),
    Item("book", 30, 10)
)

const val MAX_WEIGHT = 400

fun m(i: Int, w: Int): Triple<MutableList<Item>, Int, Int> {
    val chosen = mutableListOf<Item>()
    if (i < 0 || w == 0) return Triple(chosen, 0, 0)
    else if (wants[i].weight > w) return m(i - 1, w)
    val (l0, w0, v0) = m(i - 1, w)
    var (l1, w1, v1) = m(i - 1, w - wants[i].weight)
    v1 += wants[i].value
    if (v1 > v0) {
        l1.add(wants[i])
        return Triple(l1, w1 + wants[i].weight, v1)
    }
    return Triple(l0, w0, v0)
}

fun main(args: Array<String>) {
    val (chosenItems, totalWeight, totalValue) = m(wants.size - 1, MAX_WEIGHT)
    println("Knapsack Item Chosen    Weight Value")
    println("----------------------  ------ -----")
    for (item in chosenItems.sortedByDescending { it.value} )
        println("${item.name.padEnd(24)}  ${"%3d".format(item.weight)}    ${"%3d".format(item.value)}")
    println("----------------------  ------ -----")
    println("Total ${chosenItems.size} Items Chosen     $totalWeight   $totalValue")
}
