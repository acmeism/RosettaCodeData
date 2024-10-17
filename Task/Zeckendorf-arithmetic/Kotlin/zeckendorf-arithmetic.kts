// version 1.1.51

class Zeckendorf(x: String = "0") : Comparable<Zeckendorf> {

    var dVal = 0
    var dLen = 0

    private fun a(n: Int) {
        var i = n
        while (true) {
            if (dLen < i) dLen = i
            val j = (dVal shr (i * 2)) and 3
            when (j) {
                0, 1 -> return

                2 -> {
                    if (((dVal shr ((i + 1) * 2)) and 1) != 1) return
                    dVal += 1 shl (i * 2 + 1)
                    return
                }

                3 -> {
                    dVal = dVal and (3 shl (i * 2)).inv()
                    b((i + 1) * 2)
                }
            }
            i++
        }
    }

    private fun b(pos: Int) {
        if (pos == 0) {
            var thiz = this
            ++thiz
            return
        }
        if (((dVal shr pos) and 1) == 0) {
            dVal += 1 shl pos
            a(pos / 2)
            if (pos > 1) a(pos / 2 - 1)
        }
        else {
            dVal = dVal and (1 shl pos).inv()
            b(pos + 1)
            b(pos - (if (pos > 1) 2 else 1))
        }
    }

    private fun c(pos: Int) {
        if (((dVal shr pos) and 1) == 1) {
            dVal = dVal and (1 shl pos).inv()
            return
        }
        c(pos + 1)
        if (pos > 0) b(pos - 1) else { var thiz = this; ++thiz }
    }

    init {
        var q = 1
        var i = x.length - 1
        dLen = i / 2
        while (i >= 0) {
            dVal += (x[i] - '0').toInt() * q
            q *= 2
            i--
        }
    }

    operator fun inc(): Zeckendorf {
        dVal += 1
        a(0)
        return this
    }

    operator fun plusAssign(other: Zeckendorf) {
        for (gn in 0 until (other.dLen + 1) * 2) {
            if (((other.dVal shr gn) and 1) == 1) b(gn)
        }
    }

    operator fun minusAssign(other: Zeckendorf) {
        for (gn in 0 until (other.dLen + 1) * 2) {
            if (((other.dVal shr gn) and 1) == 1) c(gn)
        }
        while ((((dVal shr dLen * 2) and 3) == 0) || (dLen == 0)) dLen--
    }

    operator fun timesAssign(other: Zeckendorf) {
        var na = other.copy()
        var nb = other.copy()
        var nt: Zeckendorf
        var nr = "0".Z
        for (i in 0..(dLen + 1) * 2) {
            if (((dVal shr i) and 1) > 0) nr += nb
            nt = nb.copy()
            nb += na
            na = nt.copy()
        }
        dVal = nr.dVal
        dLen = nr.dLen
    }

    override operator fun compareTo(other: Zeckendorf) = dVal.compareTo(other.dVal)

    override fun toString(): String {
        if (dVal == 0) return "0"
        val sb = StringBuilder(dig1[(dVal shr (dLen * 2)) and 3])
        for (i in dLen - 1 downTo 0) {
            sb.append(dig[(dVal shr (i * 2)) and 3])
        }
        return sb.toString()
    }

    fun copy(): Zeckendorf {
        val z = "0".Z
        z.dVal = dVal
        z.dLen = dLen
        return z
    }

    companion object {
        val dig = listOf("00", "01", "10")
        val dig1 = listOf("", "1", "10")
    }
}

val String.Z get() = Zeckendorf(this)

fun main(args: Array<String>) {
    println("Addition:")
    var g = "10".Z
    g += "10".Z
    println(g)
    g += "10".Z
    println(g)
    g += "1001".Z
    println(g)
    g += "1000".Z
    println(g)
    g += "10101".Z
    println(g)
    println("\nSubtraction:")
    g = "1000".Z
    g -= "101".Z
    println(g)
    g = "10101010".Z
    g -= "1010101".Z
    println(g)
    println("\nMultiplication:")
    g = "1001".Z
    g *= "101".Z
    println(g)
    g = "101010".Z
    g += "101".Z
    println(g)
}
