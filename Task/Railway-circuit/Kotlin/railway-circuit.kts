// Version 1.2.31

const val RIGHT = 1
const val LEFT = -1
const val STRAIGHT = 0

fun normalize(tracks: IntArray): String {
    val size = tracks.size
    val a = CharArray(size) { "abc"[tracks[it] + 1] }

    /* Rotate the array and find the lexicographically lowest order
       to allow the hashmap to weed out duplicate solutions. */

    var norm = String(a)
    repeat(size) {
        val s = String(a)
        if (s < norm) norm = s
        val tmp = a[0]
        for (j in 1 until size) a[j - 1] = a[j]
        a[size - 1] = tmp
    }
    return norm
}

fun fullCircleStraight(tracks: IntArray, nStraight: Int): Boolean {
    if (nStraight == 0) return true

    // do we have the requested number of straight tracks
    if (tracks.filter { it == STRAIGHT }.count() != nStraight) return false

    // check symmetry of straight tracks: i and i + 6, i and i + 4
    val straight = IntArray(12)
    var i = 0
    var idx = 0
    while (i < tracks.size && idx >= 0) {
        if (tracks[i] == STRAIGHT) straight[idx % 12]++
        idx += tracks[i]
        i++
    }
    return !((0..5).any { straight[it] != straight[it + 6] } &&
             (0..7).any { straight[it] != straight[it + 4] })
}

fun fullCircleRight(tracks: IntArray): Boolean {
    // all tracks need to add up to a multiple of 360
    if (tracks.map { it * 30 }.sum() % 360 != 0) return false

    // check symmetry of right turns: i and i + 6, i and i + 4
    val rTurns = IntArray(12)
    var i = 0
    var idx = 0
    while (i < tracks.size && idx >= 0) {
        if (tracks[i] == RIGHT) rTurns[idx % 12]++
        idx += tracks[i]
        i++
    }
    return !((0..5).any { rTurns[it] != rTurns[it + 6] } &&
             (0..7).any { rTurns[it] != rTurns[it + 4] })
}

fun circuits(nCurved: Int, nStraight: Int) {
    val solutions = hashMapOf<String, IntArray>()
    val gen = getPermutationsGen(nCurved, nStraight)
    while (gen.hasNext()) {
        val tracks = gen.next()
        if (!fullCircleStraight(tracks, nStraight)) continue
        if (!fullCircleRight(tracks)) continue
        solutions.put(normalize(tracks), tracks.copyOf())
    }
    report(solutions, nCurved, nStraight)
}

fun getPermutationsGen(nCurved: Int, nStraight: Int): PermutationsGen {
    require((nCurved + nStraight - 12) % 4 == 0) { "input must be 12 + k * 4" }
    val trackTypes =
        if (nStraight  == 0)
            intArrayOf(RIGHT, LEFT)
        else if (nCurved == 12)
            intArrayOf(RIGHT, STRAIGHT)
        else
            intArrayOf(RIGHT, LEFT, STRAIGHT)
    return PermutationsGen(nCurved + nStraight, trackTypes)
}

fun report(sol: Map<String, IntArray>, numC: Int, numS: Int) {
    val size = sol.size
    System.out.printf("%n%d solution(s) for C%d,%d %n", size, numC, numS)
    if (numC <= 20) {
        sol.values.forEach { tracks ->
            tracks.forEach { print("%2d ".format(it)) }
            println()
        }
    }
}

class PermutationsGen(numPositions: Int, private val choices: IntArray) {
    // not thread safe
    private val indices = IntArray(numPositions)
    private val sequence = IntArray(numPositions)
    private var carry = 0

    fun next(): IntArray {
        carry = 1

        /* The generator skips the first index, so the result will always start
           with a right turn (0) and we avoid clockwise/counter-clockwise
           duplicate solutions. */
        var i = 1
        while (i < indices.size && carry > 0) {
            indices[i] += carry
            carry = 0
            if (indices[i] == choices.size) {
                carry = 1
                indices[i] = 0
            }
            i++
        }
        for (j in 0 until indices.size) sequence[j] = choices[indices[j]]
        return sequence
    }

    fun hasNext() = carry != 1
}

fun main(args: Array<String>) {
    for (n in 12..32 step 4) circuits(n, 0)
    circuits(12, 4)
}
