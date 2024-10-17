fun main() {
    println("First 10 terms of Van Eck's sequence:")
    vanEck(1, 10)
    println("")
    println("Terms 991 to 1000 of Van Eck's sequence:")
    vanEck(991, 1000)
}

private fun vanEck(firstIndex: Int, lastIndex: Int) {
    val vanEckMap = mutableMapOf<Int, Int>()
    var last = 0
    if (firstIndex == 1) {
        println("VanEck[1] = 0")
    }
    for (n in 2..lastIndex) {
        val vanEck = if (vanEckMap.containsKey(last)) n - vanEckMap[last]!! else 0
        vanEckMap[last] = n
        last = vanEck
        if (n >= firstIndex) {
            println("VanEck[$n] = $vanEck")
        }
    }
}
