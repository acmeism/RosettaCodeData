// version 1.1.2

class Item(val word: String, val weight: Int) {
    override fun toString() = "($word $weight)"
}

val items = arrayOf(
    Item("alliance",   -624),
    Item("archbishop", -915),
    Item("balm",        397),
    Item("bonnet",      452),
    Item("brute",       870),
    Item("centipede",  -658),
    Item("cobol",       362),
    Item("covariate",   590),
    Item("departure",   952),
    Item("deploy",       44),
    Item("diophantine", 645),
    Item("efferent",     54),
    Item("elysee",     -326),
    Item("eradicate",   376),
    Item("escritoire",  856),
    Item("exorcism",   -983),
    Item("fiat",        170),
    Item("filmy",      -874),
    Item("flatworm",    503),
    Item("gestapo",     915),
    Item("infra",      -847),
    Item("isis",       -982),
    Item("lindholm",    999),
    Item("markham",     475),
    Item("mincemeat",  -880),
    Item("moresby",     756),
    Item("mycenae",     183),
    Item("plugging",   -266),
    Item("smokescreen", 423),
    Item("speakeasy",  -745),
    Item("vein",        813)
)

val n = items.size
val indices = IntArray(n)
var count = 0

const val LIMIT = 5

fun zeroSum(i: Int, w: Int) {
    if (i != 0 && w == 0) {
        for (j in 0 until i) print("${items[indices[j]]} ")
        println("\n")
        if (count < LIMIT) count++ else return
    }
    val k = if (i != 0) indices[i - 1] + 1 else 0
    for (j in k until n) {
        indices[i] = j
        zeroSum(i + 1, w + items[j].weight)
        if (count == LIMIT) return
    }
}

fun main(args: Array<String>) {
    println("The weights of the following $LIMIT subsets add up to zero:\n")
    zeroSum(0, 0)
}
