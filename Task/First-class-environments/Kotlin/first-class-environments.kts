// version 1.1.3

class Environment(var seq: Int, var count: Int)

const val JOBS = 12
val envs = List(JOBS) { Environment(it + 1, 0) }
var seq = 0     // 'seq' for current environment
var count = 0   // 'count' for current environment
var currId = 0  // index of current environment

fun switchTo(id: Int) {
    if (id != currId) {
        envs[currId].seq = seq
        envs[currId].count = count
        currId = id
    }
    seq = envs[id].seq
    count = envs[id].count
}

fun hailstone() {
    print("%4d".format(seq))
    if (seq == 1) return
    count++
    seq = if (seq % 2 == 1) 3 * seq + 1 else seq / 2
}

val allDone get(): Boolean {
    for (a in 0 until JOBS) {
        switchTo(a)
        if (seq != 1) return false
    }
    return true
}

fun code() {
    do {
        for (a in 0 until JOBS) {
            switchTo(a)
            hailstone()
        }
        println()
    }
    while (!allDone)

    println("\nCOUNTS:")
    for (a in 0 until JOBS) {
        switchTo(a)
        print("%4d".format(count))
    }
    println()
}

fun main(args: Array<String>) {
    code()
}
