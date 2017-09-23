// version 1.1.2

var maxPathLength = 0
var maxPathLengthCount = 0
val maxPathExample = StringBuilder(500)

val names = arrayOf(
    "audino", "bagon", "baltoy", "banette", "bidoof",
    "braviary", "bronzor", "carracosta", "charmeleon", "cresselia",
    "croagunk", "darmanitan", "deino", "emboar", "emolga",
    "exeggcute", "gabite", "girafarig", "gulpin", "haxorus",
    "heatmor", "heatran", "ivysaur", "jellicent", "jumpluff",
    "kangaskhan", "kricketune", "landorus", "ledyba", "loudred",
    "lumineon", "lunatone", "machamp", "magnezone", "mamoswine",
    "nosepass", "petilil", "pidgeotto", "pikachu", "pinsir",
    "poliwrath", "poochyena", "porygon2", "porygonz", "registeel",
    "relicanth", "remoraid", "rufflet", "sableye", "scolipede",
    "scrafty", "seaking", "sealeo", "silcoon", "simisear",
    "snivy", "snorlax", "spoink", "starly", "tirtouga",
    "trapinch", "treecko", "tyrogue", "vigoroth", "vulpix",
    "wailord", "wartortle", "whismur", "wingull", "yamask"
)

fun search(part: Array<String>, offset: Int) {
    if (offset > maxPathLength) {
        maxPathLength = offset
        maxPathLengthCount = 1
    }
    else if (offset == maxPathLength) {
        maxPathLengthCount++
        maxPathExample.setLength(0)
        for (i in 0 until offset) {
            maxPathExample.append(if (i % 5 == 0) "\n  " else " ")
            maxPathExample.append(part[i])
        }
    }
    val lastChar = part[offset - 1].last()
    for (i in offset until part.size) {
        if (part[i][0] == lastChar) {
            val tmp = names[offset]
            names[offset] = names[i]
            names[i] = tmp
            search(names, offset + 1)
            names[i] = names[offset]
            names[offset] = tmp
        }
    }
}

fun main(args: Array<String>) {
    for (i in 0 until names.size) {
        val tmp = names[0]
        names[0] = names[i]
        names[i] = tmp
        search(names, 1)
        names[i] = names[0]
        names[0] = tmp
    }
    println("Maximum path length         : $maxPathLength")
    println("Paths of that length        : $maxPathLengthCount")
    println("Example path of that length : $maxPathExample")
}
