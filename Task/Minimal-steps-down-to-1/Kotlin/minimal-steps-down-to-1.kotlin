fun main() {
    runTasks(getFunctions1())
    runTasks(getFunctions2())
    runTasks(getFunctions3())
}

fun runTasks(functions: List<Function>) {
    val minPath = getInitialMap(functions, 5)

    // Task 1
    val max = 10
    populateMap(minPath, functions, max)
    println("\nWith functions: $functions")
    println("  Minimum steps to 1:")
    for (n in 2..max) {
        val steps = minPath[n]?.size ?: 0
        println("    %2d: %d step%s: %s".format(n, steps, if (steps == 1) "" else "s", minPath[n]))
    }

    // Task 2
    displayMaxMin(minPath, functions, 2000)

    // Task 2a
    displayMaxMin(minPath, functions, 20000)

    // Task 2a +
    displayMaxMin(minPath, functions, 100000)
}

fun displayMaxMin(minPath: MutableMap<Int, List<String>>, functions: List<Function>, max: Int) {
    populateMap(minPath, functions, max)
    val maxIntegers = getMaxMin(minPath, max)
    val maxSteps = maxIntegers.removeAt(0)
    val numCount = maxIntegers.size
    println("  There ${if (numCount == 1) "is" else "are"} $numCount number${if (numCount == 1) "" else "s"} in the range 1-$max that have maximum 'minimal steps' of $maxSteps:\n    $maxIntegers")
}

fun getMaxMin(minPath: Map<Int, List<String>>, max: Int): MutableList<Int> {
    var maxSteps = Int.MIN_VALUE
    val maxIntegers = mutableListOf<Int>()
    for (n in 2..max) {
        val len = minPath[n]?.size ?: 0
        if (len > maxSteps) {
            maxSteps = len
            maxIntegers.clear()
            maxIntegers.add(n)
        } else if (len == maxSteps) {
            maxIntegers.add(n)
        }
    }
    maxIntegers.add(0, maxSteps)
    return maxIntegers
}

fun populateMap(minPath: MutableMap<Int, List<String>>, functions: List<Function>, max: Int) {
    for (n in 2..max) {
        if (n in minPath) continue
        var minFunction: Function? = null
        var minSteps = Int.MAX_VALUE
        for (f in functions) {
            if (f.actionOk(n)) {
                val result = f.action(n)
                val steps = 1 + (minPath[result]?.size ?: 0)
                if (steps < minSteps) {
                    minFunction = f
                    minSteps = steps
                }
            }
        }
        minFunction?.let {
            val result = it.action(n)
            val path = mutableListOf(it.toString(n))
            path.addAll(minPath[result] ?: emptyList())
            minPath[n] = path
        }
    }
}

fun getInitialMap(functions: List<Function>, max: Int): MutableMap<Int, List<String>> {
    val minPath = mutableMapOf<Int, List<String>>()
    for (i in 2..max) {
        for (f in functions) {
            if (f.actionOk(i)) {
                val result = f.action(i)
                if (result == 1) {
                    minPath[i] = listOf(f.toString(i))
                }
            }
        }
    }
    return minPath
}

fun getFunctions1(): List<Function> = listOf(
    Divide3Function(),
    Divide2Function(),
    Subtract1Function()
)

fun getFunctions2(): List<Function> = listOf(
    Divide3Function(),
    Divide2Function(),
    Subtract2Function()
)

fun getFunctions3(): List<Function> = listOf(
    Divide2Function(),
    Divide3Function(),
    Subtract2Function(),
    Subtract1Function()
)

abstract class Function {
    abstract fun action(n: Int): Int
    abstract fun actionOk(n: Int): Boolean
    abstract fun toString(n: Int): String
}

class Divide2Function : Function() {
    override fun action(n: Int) = n / 2
    override fun actionOk(n: Int) = n % 2 == 0
    override fun toString(n: Int) = "/2 -> ${n / 2}"
    override fun toString() = "Divisor 2"
}

class Divide3Function : Function() {
    override fun action(n: Int) = n / 3
    override fun actionOk(n: Int) = n % 3 == 0
    override fun toString(n: Int) = "/3 -> ${n / 3}"
    override fun toString() = "Divisor 3"
}

class Subtract1Function : Function() {
    override fun action(n: Int) = n - 1
    override fun actionOk(n: Int) = true
    override fun toString(n: Int) = "-1 -> ${n - 1}"
    override fun toString() = "Subtractor 1"
}

class Subtract2Function : Function() {
    override fun action(n: Int) = n - 2
    override fun actionOk(n: Int) = n > 2
    override fun toString(n: Int) = "-2 -> ${n - 2}"
    override fun toString() = "Subtractor 2"
}
