// version 1.1.51

fun mostFreqKHashing(input: String, k: Int): String =
    input.groupBy { it }.map { Pair(it.key, it.value.size) }
                        .sortedByDescending { it.second } // preserves original order when equal
                        .take(k)
                        .fold("") { acc, v -> acc + "${v.first}${v.second.toChar()}" }

fun mostFreqKSimilarity(input1: String, input2: String): Int {
    var similarity = 0
    for (i in 0 until input1.length step 2) {
        for (j in 0 until input2.length step 2) {
            if (input1[i] == input2[j]) {
                val freq1 = input1[i + 1].toInt()
                val freq2 = input2[j + 1].toInt()
                if (freq1 != freq2) continue  // assuming here that frequencies need to match
                similarity += freq1
            }
        }
    }
    return similarity
}

fun mostFreqKSDF(input1: String, input2: String, k: Int, maxDistance: Int) {
    println("input1 : $input1")
    println("input2 : $input2")
    val s1 = mostFreqKHashing(input1, k)
    val s2 = mostFreqKHashing(input2, k)
    print("mfkh(input1, $k) = ")
    for ((i, c) in s1.withIndex()) print(if (i % 2 == 0) c.toString() else c.toInt().toString())
    print("\nmfkh(input2, $k) = ")
    for ((i, c) in s2.withIndex()) print(if (i % 2 == 0) c.toString() else c.toInt().toString())
    val result = maxDistance - mostFreqKSimilarity(s1, s2)
    println("\nSDF(input1, input2, $k, $maxDistance) = $result\n")
}

fun main(args: Array<String>) {
    val pairs = listOf(
        Pair("research", "seeking"),
        Pair("night", "nacht"),
        Pair("my", "a"),
        Pair("research", "research"),
        Pair("aaaaabbbb", "ababababa"),
        Pair("significant", "capabilities")
    )
    for (pair in pairs) mostFreqKSDF(pair.first, pair.second, 2, 10)

    var s1 = "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV"
    var s2 = "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"
    mostFreqKSDF(s1, s2, 2, 100)
    s1 = "abracadabra12121212121abracadabra12121212121"
    s2 = s1.reversed()
    mostFreqKSDF(s1, s2, 2, 100)
}
