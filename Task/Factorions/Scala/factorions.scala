object Factorion extends App {
    private def is_factorion(i: Int, b: Int): Boolean = {
        var sum = 0L
        var j = i
        while (j > 0) {
            sum +=  f(j % b)
            j /= b
        }
        sum == i
    }

    private val f = Array.ofDim[Long](12)
    f(0) = 1L
    (1 until 12).foreach(n => f(n) = f(n - 1) * n)
    (9 to 12).foreach(b => {
        print(s"factorions for base $b:")
        (1 to 1500000).filter(is_factorion(_, b)).foreach(i => print(s" $i"))
        println
    })
}
