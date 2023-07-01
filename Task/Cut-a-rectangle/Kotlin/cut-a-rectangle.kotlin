// version 1.0.6

object RectangleCutter {
    private var w: Int = 0
    private var h: Int = 0
    private var len: Int = 0
    private var cnt: Long = 0

    private lateinit var grid: ByteArray
    private val next = IntArray(4)
    private val dir = arrayOf(
        intArrayOf(0, -1),
        intArrayOf(-1, 0),
        intArrayOf(0, 1),
        intArrayOf(1, 0)
    )

    private fun walk(y: Int, x: Int) {
        if (y == 0 || y == h || x == 0 || x == w) {
            cnt += 2
            return
        }
        val t = y * (w + 1) + x
        grid[t]++
        grid[len - t]++
        (0..3).filter { grid[t + next[it]] == 0.toByte() }
            .forEach { walk(y + dir[it][0], x + dir[it][1]) }
        grid[t]--
        grid[len - t]--
    }

    fun solve(hh: Int, ww: Int, recur: Boolean): Long {
        var t: Int
        h = hh
        w = ww
        if ((h and 1) != 0) {
            t = w
            w = h
            h = t
        }
        if ((h and 1) != 0) return 0L
        if (w == 1) return 1L
        if (w == 2) return h.toLong()
        if (h == 2) return w.toLong()
        val cy = h / 2
        val cx = w / 2
        len = (h + 1) * (w + 1)
        grid = ByteArray(len)
        len--
        next[0] = -1
        next[1] = -w - 1
        next[2] = 1
        next[3] = w + 1
        if (recur) cnt = 0L
        for (x in cx + 1 until w) {
            t = cy * (w + 1) + x
            grid[t] = 1
            grid[len - t] = 1
            walk(cy - 1, x)
        }
        cnt++
        if (h == w) cnt *= 2
        else if ((w and 1) == 0 && recur) solve(w, h, false)
        return cnt
    }
}

fun main(args: Array<String>) {
    for (y in 1..10) {
        for (x in 1..y) {
            if ((x and 1) == 0 || (y and 1) == 0) {
                println("${"%2d".format(y)} x ${"%2d".format(x)}: ${RectangleCutter.solve(y, x, true)}")
            }
        }
    }
}
