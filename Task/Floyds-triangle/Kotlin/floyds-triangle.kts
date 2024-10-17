fun main(args: Array<String>) = args.forEach { Triangle(it.toInt()) }

internal class Triangle(n: Int) {
    init {
        println("$n rows:")
        var printMe = 1
        var printed = 0
        var row = 1
        while (row <= n) {
            val cols = Math.ceil(Math.log10(n * (n - 1) / 2 + printed + 2.0)).toInt()
            print("%${cols}d ".format(printMe))
            if (++printed == row) { println(); row++; printed = 0 }
            printMe++
        }
    }
}
