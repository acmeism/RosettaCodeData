// version 1.1.3

typealias Predicate = (String) -> Boolean

val predicates = listOf<Predicate>(
    { it.length == 13 },  // indexing starts at 0 but first bit ignored
    { (7..12).count { i -> it[i] == '1' } == 3 },
    { (2..12 step 2).count { i -> it[i] == '1' } == 2 },
    { it[5] == '0' || (it[6] == '1' && it[7] == '1') },
    { it[2] == '0' && it[3]  == '0' && it[4] == '0' },
    { (1..11 step 2).count { i -> it[i] == '1' } == 4 },
    { (it[2] == '1') xor (it[3] == '1') },
    { it[7] == '0' || (it[5] == '1' && it[6] == '1') },
    { (1..6).count { i -> it[i] == '1' } == 3 },
    { it[11] == '1' && it[12] == '1' },
    { (7..9).count { i -> it[i] == '1' } == 1 },
    { (1..11).count { i -> it[i] == '1' } == 4 }
)

fun show(s: String, indent: Boolean) {
    if (indent) print("    ")
    for (i in s.indices) if (s[i] == '1') print("$i ")
    println()
}

fun main(args: Array<String>) {
    println("Exact hits:")
    for (i in 0..4095) {
        val s = i.toString(2).padStart(13, '0')
        var j = 1
        if (predicates.all { it(s) == (s[j++] == '1') }) show(s, true)
    }

    println("\nNear misses:")
    for (i in 0..4095) {
        val s = i.toString(2).padStart(13, '0')
        var j = 1
        if (predicates.count { it(s) == (s[j++] == '1') } == 11) {
            var k = 1
            val iof = predicates.indexOfFirst { it(s) != (s[k++] == '1') } + 1
            print("    (Fails at statement ${"%2d".format(iof)})  ")
            show(s, false)
        }
    }
}
