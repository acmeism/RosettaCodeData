// version 1.1.51

class Expression {

    private enum class Op { ADD, SUB, JOIN }
    private val code = Array<Op>(NUMBER_OF_DIGITS) { Op.ADD }

    companion object {
        private const val NUMBER_OF_DIGITS = 9
        private const val THREE_POW_4 = 3 * 3 * 3 * 3
        private const val FMT = "%9d"
        const val NUMBER_OF_EXPRESSIONS = 2 * THREE_POW_4 * THREE_POW_4

        fun print(givenSum: Int) {
            var expression = Expression()
            repeat(Expression.NUMBER_OF_EXPRESSIONS) {
                if (expression.toInt() == givenSum) println("${FMT.format(givenSum)} = $expression")
                expression++
            }
        }
    }

    operator fun inc(): Expression {
        for (i in 0 until code.size) {
            code[i] = when (code[i]) {
                Op.ADD  -> Op.SUB
                Op.SUB  -> Op.JOIN
                Op.JOIN -> Op.ADD
            }
            if (code[i] != Op.ADD) break
        }
        return this
    }

    fun toInt(): Int {
        var value = 0
        var number = 0
        var sign = +1
        for (digit in 1..9) {
            when (code[NUMBER_OF_DIGITS - digit]) {
                Op.ADD  -> { value += sign * number; number = digit; sign = +1 }
                Op.SUB  -> { value += sign * number; number = digit; sign = -1 }
                Op.JOIN -> { number = 10 * number + digit }
            }
        }
        return value + sign * number
    }

    override fun toString(): String {
        val sb = StringBuilder()
        for (digit in 1..NUMBER_OF_DIGITS) {
            when (code[NUMBER_OF_DIGITS - digit]) {
                Op.ADD  -> if (digit > 1) sb.append(" + ")
                Op.SUB  -> sb.append(" - ")
                Op.JOIN -> {}
            }
            sb.append(digit)
        }
        return sb.toString().trimStart()
    }
}

class Stat {

    val countSum = mutableMapOf<Int, Int>()
    val sumCount = mutableMapOf<Int, MutableSet<Int>>()

    init {
        var expression = Expression()
        repeat (Expression.NUMBER_OF_EXPRESSIONS) {
            val sum = expression.toInt()
            countSum.put(sum, 1 + (countSum[sum] ?: 0))
            expression++
        }
        for ((k, v) in countSum) {
            val set = if (sumCount.containsKey(v))
                sumCount[v]!!
            else
                mutableSetOf<Int>()
            set.add(k)
            sumCount.put(v, set)
        }
    }
}

fun main(args: Array<String>) {
    println("100 has the following solutions:\n")
    Expression.print(100)

    val stat = Stat()
    val maxCount = stat.sumCount.keys.max()
    val maxSum = stat.sumCount[maxCount]!!.max()
    println("\n$maxSum has the maximum number of solutions, namely $maxCount")

    var value = 0
    while (stat.countSum.containsKey(value)) value++
    println("\n$value is the lowest positive number with no solutions")

    println("\nThe ten highest numbers that do have solutions are:\n")
    stat.countSum.keys.toIntArray().sorted().reversed().take(10).forEach { Expression.print(it) }
}
