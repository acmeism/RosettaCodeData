// version 1.1.3

class VList<T : Any?> {

    private class VSeg {
        var next: VSeg? = null
        lateinit var ele: Array<Any?>
    }

    private var base: VSeg? = null
    private var offset = 0

    /* locate kth element */
    operator fun get(k: Int): T {
        var i = k
        if (i >= 0) {
            i += offset
            var sg = base
            while (sg != null) {
                @Suppress("UNCHECKED_CAST")
                if (i < sg.ele.size) return sg.ele[i] as T
                i -= sg.ele.size
                sg = sg.next
            }
        }
        throw IllegalArgumentException("Index out of range")
    }

    /* add an element to the front of VList */
    fun cons(a: T): VList<T> {
        if (this.base == null) {
            val v = VList<T>()
            val s = VSeg()
            s.ele = arrayOf<Any?>(a)
            v.base = s
            return v
        }
        if (this.offset == 0) {
            val l2 = this.base!!.ele.size * 2
            val ele = arrayOfNulls<Any>(l2)
            ele[l2 - 1] = a
            val v = VList<T>()
            val s = VSeg()
            s.next = this.base
            s.ele = ele
            v.base = s
            v.offset = l2 - 1
            return v
        }
        this.offset--
        this.base!!.ele[this.offset] = a
        return this
    }

    /* obtain a new VList beginning at the second element of an old VList */
    fun cdr(): VList<T> {
        if (base == null) throw RuntimeException("cdr invoked on empty VList")
        offset++
        if (offset < base!!.ele.size) return this
        val v = VList<T>()
        v.base = this.base!!.next
        return v
    }

    /* compute the size of the VList */
    val size: Int
        get() {
            if (base == null) return 0
            return base!!.ele.size * 2 - offset - 1
        }

    override fun toString(): String {
        if (base == null) return "[]"
        var r = "[${base!!.ele[offset]}"
        var sg = base
        var sl = base!!.ele.sliceArray(offset + 1..base!!.ele.lastIndex)
        while (true) {
            for (e in sl) r += " $e"
            sg = sg!!.next
            if (sg == null) break
            sl = sg.ele
        }
        return r + "]"
    }

    fun printStructure() {
        println("Offset: $offset")
        var sg = base
        while (sg != null) {
            println(sg.ele.contentToString())
            sg = sg.next
        }
        println()
    }
}

fun main(args: Array<String>) {
    var v = VList<Int>()
    println("Before adding any elements, empty VList: $v")
    v.printStructure()

    for (a in 6 downTo 1) v = v.cons(a)
    println("Demonstrating cons method, 6 elements added: $v")
    v.printStructure()

    v = v.cdr()
    println("Demonstrating cdr method, 1 element removed: $v")
    v.printStructure()

    println("Demonstrating size property, size = ${v.size}\n")
    println("Demonstrating element access, v[3] = ${v[3]}\n")

    v = v.cdr().cdr()
    println("Demonstrating cdr method again, 2 more elements removed: $v")
    v.printStructure()
}
