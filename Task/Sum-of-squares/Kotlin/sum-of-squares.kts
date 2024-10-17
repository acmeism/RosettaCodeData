import kotlin.random.Random
import kotlin.system.measureTimeMillis
import kotlin.time.milliseconds

enum class Summer {
    MAPPING {
        override fun sum(values: DoubleArray) = values.map {it * it}.sum()
    },
    SEQUENCING {
        override fun sum(values: DoubleArray) = values.asSequence().map {it * it}.sum()
    },
    FOLDING {
        override fun sum(values: DoubleArray) = values.fold(0.0) {acc, it -> acc + it * it}
    },
    FOR_LOOP {
        override fun sum(values: DoubleArray): Double {
            var sum = 0.0
            values.forEach { sum += it * it }
            return sum
        }
    },
    ;
    abstract fun sum(values: DoubleArray): Double
}

fun main() {
    run {
        val testArrays = listOf(
            doubleArrayOf(),
            doubleArrayOf(Random.nextInt(100) / 10.0),
            DoubleArray(6) { Random.nextInt(100) / 10.0 },
        )
        for (impl in Summer.values()) {
            println("Test with ${impl.name}:")
            for (v in testArrays) println("  ${v.contentToString()} -> ${impl.sum(v)}")
        }
    }

    run {
        val elements = 100_000
        val longArray = DoubleArray(elements) { Random.nextDouble(10.0) }

        for (impl in Summer.values()) {
            val time = measureTimeMillis {
                impl.sum(longArray)
            }.milliseconds
            println("Summing $elements with ${impl.name} takes: $time")
        }
        var acc = 0.0
        for (v in longArray) acc += v
    }
}
