// version 1.2.10

class FCNode(val name: String, val weight: Int = 1, coverage: Double = 0.0) {

    var coverage = coverage
        set(value) {
            if (field != value) {
               field = value
               // update any parent's coverage
               if (parent != null) parent!!.updateCoverage()
            }
        }

    val children = mutableListOf<FCNode>()
    var parent: FCNode? = null

    fun addChildren(nodes: List<FCNode>) {
        children.addAll(nodes)
        nodes.forEach { it.parent = this }
        updateCoverage()
    }

    private fun updateCoverage() {
        val v1 = children.sumByDouble { it.weight * it.coverage }
        val v2 = children.sumBy { it.weight }
        coverage = v1 / v2
    }

    fun show(level: Int = 0) {
        val indent = level * 4
        val nl = name.length + indent
        print(name.padStart(nl))
        print("|".padStart(32 - nl))
        print("  %3d   |".format(weight))
        println(" %8.6f |".format(coverage))
        if (children.size == 0) return
        for (child in children) child.show(level + 1)
    }
}

val houses = listOf(
    FCNode("house1", 40),
    FCNode("house2", 60)
)

val house1 = listOf(
    FCNode("bedrooms", 1, 0.25),
    FCNode("bathrooms"),
    FCNode("attic", 1, 0.75),
    FCNode("kitchen", 1, 0.1),
    FCNode("living_rooms"),
    FCNode("basement"),
    FCNode("garage"),
    FCNode("garden", 1, 0.8)
)

val house2 = listOf(
    FCNode("upstairs"),
    FCNode("groundfloor"),
    FCNode("basement")
)

val h1Bathrooms = listOf(
    FCNode("bathroom1", 1, 0.5),
    FCNode("bathroom2"),
    FCNode("outside_lavatory", 1, 1.0)
)

val h1LivingRooms = listOf(
    FCNode("lounge"),
    FCNode("dining_room"),
    FCNode("conservatory"),
    FCNode("playroom", 1, 1.0)
)

val h2Upstairs = listOf(
    FCNode("bedrooms"),
    FCNode("bathroom"),
    FCNode("toilet"),
    FCNode("attics", 1, 0.6)
)

val h2Groundfloor = listOf(
    FCNode("kitchen"),
    FCNode("living_rooms"),
    FCNode("wet_room_&_toilet"),
    FCNode("garage"),
    FCNode("garden", 1, 0.9),
    FCNode("hot_tub_suite", 1, 1.0)
)

val h2Basement = listOf(
    FCNode("cellars", 1, 1.0),
    FCNode("wine_cellar", 1, 1.0),
    FCNode("cinema", 1, 0.75)
)

val h2UpstairsBedrooms = listOf(
    FCNode("suite_1"),
    FCNode("suite_2"),
    FCNode("bedroom_3"),
    FCNode("bedroom_4")
)

val h2GroundfloorLivingRooms = listOf(
    FCNode("lounge"),
    FCNode("dining_room"),
    FCNode("conservatory"),
    FCNode("playroom")
)

fun main(args: Array<String>) {
    val cleaning = FCNode("cleaning")

    house1[1].addChildren(h1Bathrooms)
    house1[4].addChildren(h1LivingRooms)
    houses[0].addChildren(house1)

    h2Upstairs[0].addChildren(h2UpstairsBedrooms)
    house2[0].addChildren(h2Upstairs)
    h2Groundfloor[1].addChildren(h2GroundfloorLivingRooms)
    house2[1].addChildren(h2Groundfloor)
    house2[2].addChildren(h2Basement)
    houses[1].addChildren(house2)

    cleaning.addChildren(houses)
    val topCoverage = cleaning.coverage
    println("TOP COVERAGE = ${"%8.6f".format(topCoverage)}\n")
    println("NAME HIERARCHY                 | WEIGHT | COVERAGE |")
    cleaning.show()

    h2Basement[2].coverage = 1.0  // change Cinema node coverage to 1.0
    val diff = cleaning.coverage - topCoverage
    println("\nIf the coverage of the Cinema node were increased from 0.75 to 1.0")
    print("the top level coverage would increase by ")
    println("${"%8.6f".format(diff)} to ${"%8.6f".format(topCoverage + diff)}")
    h2Basement[2].coverage = 0.75  // restore to original value if required
}
