// version 1.0.6

fun rescale(price: Double): Double =
    when {
        price < 0.06 ->  0.10
        price < 0.11 ->  0.18
        price < 0.16 ->  0.26
        price < 0.21 ->  0.32
        price < 0.26 ->  0.38
        price < 0.31 ->  0.44
        price < 0.36 ->  0.50
        price < 0.41 ->  0.54
        price < 0.46 ->  0.58
        price < 0.51 ->  0.62
        price < 0.56 ->  0.66
        price < 0.61 ->  0.70
        price < 0.66 ->  0.74
        price < 0.71 ->  0.78
        price < 0.76 ->  0.82
        price < 0.81 ->  0.86
        price < 0.86 ->  0.90
        price < 0.91 ->  0.94
        price < 0.96 ->  0.98
        else         ->  1.00
    }

fun main(args: Array<String>) {
    var d: Double
    for (i in 1..100) {
        d = i / 100.0
        print(String.format("%4.2f -> %4.2f  ", d, rescale(d)))
        if (i % 5 == 0) println()
    }
}
