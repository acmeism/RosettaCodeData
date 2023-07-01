// Version 1.2.70

class Example(val start: Int, val stop: Int, val incr: Int, val comment: String)

var examples = listOf(
    Example(-2, 2, 1, "Normal"),
    Example(-2, 2, 0, "Zero increment"),
    Example(-2, 2, -1, "Increments away from stop value"),
    Example(-2, 2, 10, "First increment is beyond stop value"),
    Example(2, -2, 1, "Start more than stop: positive increment"),
    Example(2, 2, 1, "Start equal stop: positive increment"),
    Example(2, 2, -1, "Start equal stop: negative increment"),
    Example(2, 2, 0, "Start equal stop: zero increment"),
    Example(0, 0, 0, "Start equal stop equal zero: zero increment")
)

fun sequence(ex: Example, limit: Int) =
    if (ex.incr == 0) {
        List(limit) { ex.start }
    }
    else {
        val res = mutableListOf<Int>()
        var c = 0
        var i = ex.start
        while (i <= ex.stop && c < limit) {
            res.add(i)
            i += ex.incr
            c++
        }
        res
    }

fun main(args: Array<String>) {
    for (ex in examples) {
        println(ex.comment)
        System.out.printf("Range(%d, %d, %d) -> ", ex.start, ex.stop, ex.incr)
        println(sequence(ex, 10))
        println()
    }
}
