object Heron extends scala.collection.mutable.MutableList[Seq[Int]] with App {
    private final val n = 200
    for (c <- 1 to n; b <- 1 to c; a <- 1 to b if gcd(gcd(a, b), c) == 1) {
        val p = a + b + c
        val s = p / 2D
        val area = Math.sqrt(s * (s - a) * (s - b) * (s - c))
        if (isHeron(area))
            appendElem(Seq(a, b, c, p, area.toInt))
    }
    print(s"Number of primitive Heronian triangles with sides up to $n: " + length)

    private final val list = sortBy(i => (i(4), i(3)))
    print("\n\nFirst ten when ordered by increasing area, then perimeter:" + header)
    list slice (0, 10) map format foreach print
    print("\n\nArea = 210" + header)
    list filter { _(4) == 210 } map format foreach print

    private def gcd(a: Int, b: Int) = {
        var leftover = 1
        var (dividend, divisor) = if (a > b) (a, b) else (b, a)
        while (leftover != 0) {
            leftover = dividend % divisor
            if (leftover > 0) {
                dividend = divisor
                divisor = leftover
            }
        }
        divisor
    }

    private def isHeron(h: Double) = h % 1 == 0 && h > 0

    private final val header = "\nSides           Perimeter   Area"
    private def format: Seq[Int] => String = "\n%3d x %3d x %3d %5d %10d".format
}
