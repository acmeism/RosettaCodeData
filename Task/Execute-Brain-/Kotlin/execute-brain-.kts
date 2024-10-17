// version 1.1.2

class Brainf__k(val prog: String, memSize: Int) {
    private val mem = IntArray(memSize)
    private var ip = 0
    private var dp = 0
    private val memVal get() = mem.getOrElse(dp) { 0 }

    fun execute() {
        while (ip < prog.length) {
            when (prog[ip++]) {
                '>' -> dp++
                '<' -> dp--
                '+' -> mem[dp] = memVal + 1
                '-' -> mem[dp] = memVal - 1
                ',' -> mem[dp] = System.`in`.read()
                '.' -> print(memVal.toChar())
                '[' -> handleLoopStart()
                ']' -> handleLoopEnd()
            }
        }
    }

    private fun handleLoopStart() {
        if (memVal != 0) return
        var depth = 1
        while (ip < prog.length) {
            when (prog[ip++]) {
                '[' -> depth++
                ']' -> if (--depth == 0) return
            }
        }
        throw IllegalStateException("Could not find matching end bracket")
    }

    private fun handleLoopEnd() {
        var depth = 0
        while (ip >= 0) {
            when (prog[--ip]) {
                ']' -> depth++
                '[' -> if (--depth == 0) return
            }
        }
        throw IllegalStateException("Could not find matching start bracket")
    }
}

fun main(args: Array<String>) {
    val prog = "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
    Brainf__k(prog, 10).execute()
}
