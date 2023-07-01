// version 1.0.6

// Uses the "iterative with two matrix rows" algorithm referred to in the Wikipedia article.

fun levenshtein(s: String, t: String): Int {
    // degenerate cases
    if (s == t)  return 0
    if (s == "") return t.length
    if (t == "") return s.length

    // create two integer arrays of distances and initialize the first one
    val v0 = IntArray(t.length + 1) { it }  // previous
    val v1 = IntArray(t.length + 1)         // current

    var cost: Int
    for (i in 0 until s.length) {
        // calculate v1 from v0
        v1[0] = i + 1
        for (j in 0 until t.length) {
            cost = if (s[i] == t[j]) 0 else 1
            v1[j + 1] = Math.min(v1[j] + 1, Math.min(v0[j + 1] + 1, v0[j] + cost))
        }
        // copy v1 to v0 for next iteration
        for (j in 0 .. t.length) v0[j] = v1[j]
    }
    return v1[t.length]
}

fun main(args: Array<String>) {
    println("'kitten' to 'sitting'            => ${levenshtein("kitten", "sitting")}")
    println("'rosettacode' to 'raisethysword' => ${levenshtein("rosettacode", "raisethysword")}")
    println("'sleep' to 'fleeting'            => ${levenshtein("sleep", "fleeting")}")
}
