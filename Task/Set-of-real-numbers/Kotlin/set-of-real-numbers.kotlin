// version 1.1.4-3

typealias RealPredicate = (Double) -> Boolean

enum class RangeType { CLOSED, BOTH_OPEN, LEFT_OPEN, RIGHT_OPEN }

class RealSet(val low: Double, val high: Double, val predicate: RealPredicate) {

    constructor (start: Double, end: Double, rangeType: RangeType): this(start, end,
        when (rangeType) {
            RangeType.CLOSED     -> fun(d: Double) = d in start..end
            RangeType.BOTH_OPEN  -> fun(d: Double) = start < d && d < end
            RangeType.LEFT_OPEN  -> fun(d: Double) = start < d && d <= end
            RangeType.RIGHT_OPEN -> fun(d: Double) = start <= d && d < end
        }
    )

    fun contains(d: Double) = predicate(d)

    infix fun union(other: RealSet): RealSet {
        val low2 = minOf(low, other.low)
        val high2 = maxOf(high, other.high)
        return RealSet(low2, high2) { predicate(it) || other.predicate(it) }
    }

    infix fun intersect(other: RealSet): RealSet {
        val low2 = maxOf(low, other.low)
        val high2 = minOf(high, other.high)
        return RealSet(low2, high2) { predicate(it) && other.predicate(it) }
    }

    infix fun subtract(other: RealSet) = RealSet(low, high) { predicate(it) && !other.predicate(it) }

    var interval = 0.00001

    val length: Double get() {
        if (!low.isFinite() || !high.isFinite()) return -1.0  // error value
        if (high <= low) return 0.0
        var p = low
        var count = 0
        do {
            if (predicate(p)) count++
            p += interval
        }
        while (p < high)
        return count * interval
    }

    fun isEmpty() = if (high == low) !predicate(low) else length == 0.0
}

fun main(args: Array<String>) {
    val a = RealSet(0.0, 1.0, RangeType.LEFT_OPEN)
    val b = RealSet(0.0, 2.0, RangeType.RIGHT_OPEN)
    val c = RealSet(1.0, 2.0, RangeType.LEFT_OPEN)
    val d = RealSet(0.0, 3.0, RangeType.RIGHT_OPEN)
    val e = RealSet(0.0, 1.0, RangeType.BOTH_OPEN)
    val f = RealSet(0.0, 1.0, RangeType.CLOSED)
    val g = RealSet(0.0, 0.0, RangeType.CLOSED)

    for (i in 0..2) {
        val dd = i.toDouble()
        println("(0, 1] ∪ [0, 2) contains $i is ${(a union b).contains(dd)}")
        println("[0, 2) ∩ (1, 2] contains $i is ${(b intersect c).contains(dd)}")
        println("[0, 3) − (0, 1) contains $i is ${(d subtract e).contains(dd)}")
        println("[0, 3) − [0, 1] contains $i is ${(d subtract f).contains(dd)}\n")
    }

    println("[0, 0] is empty is ${g.isEmpty()}\n")

    val aa = RealSet(0.0, 10.0) { x -> (0.0 < x && x < 10.0) &&
                                        Math.abs(Math.sin(Math.PI * x * x)) > 0.5  }
    val bb = RealSet(0.0, 10.0) { x -> (0.0 < x && x < 10.0) &&
                                        Math.abs(Math.sin(Math.PI * x)) > 0.5  }
    val cc = aa subtract bb
    println("Approx length of A - B is ${cc.length}")
}
