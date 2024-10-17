import java.util.ArrayList

object Heron {
    private val n = 200

    fun run() {
        val l = ArrayList<IntArray>()
        for (c in 1..n)
            for (b in 1..c)
                for (a in 1..b)
                    if (gcd(gcd(a, b), c) == 1) {
                        val p = a + b + c
                        val s = p / 2.0
                        val area = Math.sqrt(s * (s - a) * (s - b) * (s - c))
                        if (isHeron(area))
                            l.add(intArrayOf(a, b, c, p, area.toInt()))
                    }
        print("Number of primitive Heronian triangles with sides up to $n: " + l.size)

        sort(l)
        print("\n\nFirst ten when ordered by increasing area, then perimeter:" + header)
        for (i in 0 until 10) {
            print(format(l[i]))
        }
        val a = 210
        print("\n\nArea = $a" + header)
        l.filter { it[4] == a }.forEach { print(format(it)) }
    }

    private fun gcd(a: Int, b: Int): Int {
        var leftover = 1
        var dividend = if (a > b) a else b
        var divisor = if (a > b) b else a
        while (leftover != 0) {
            leftover = dividend % divisor
            if (leftover > 0) {
                dividend = divisor
                divisor = leftover
            }
        }
        return divisor
    }

    fun sort(l: MutableList<IntArray>) {
        var swapped = true
        while (swapped) {
            swapped = false
            for (i in 1 until l.size)
                if (l[i][4] < l[i - 1][4] || l[i][4] == l[i - 1][4] && l[i][3] < l[i - 1][3]) {
                    val temp = l[i]
                    l[i] = l[i - 1]
                    l[i - 1] = temp
                    swapped = true
                }
        }
    }

    private fun isHeron(h: Double) = h.rem(1) == 0.0 && h > 0

    private val header = "\nSides           Perimeter   Area"
    private fun format(a: IntArray) = "\n%3d x %3d x %3d %5d %10d".format(a[0], a[1], a[2], a[3], a[4])
}

fun main(args: Array<String>) = Heron.run()
