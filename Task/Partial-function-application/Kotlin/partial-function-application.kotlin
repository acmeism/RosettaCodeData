// version 1.1.2

typealias Func  = (Int) -> Int
typealias FuncS = (Func, List<Int>) -> List<Int>

fun fs(f: Func, seq: List<Int>) = seq.map { f(it) }

fun partial(fs: FuncS, f: Func) = { seq: List<Int> -> fs(f, seq) }

fun f1(n: Int) = 2 * n

fun f2(n: Int) = n * n

fun main(args: Array<String>) {
    val fsf1 = partial(::fs, ::f1)
    val fsf2 = partial(::fs, ::f2)
    val seqs = listOf(
        listOf(0, 1, 2, 3),
        listOf(2, 4, 6, 8)
    )
    for (seq in seqs) {
        println(fs(::f1, seq))      // normal
        println(fsf1(seq))          // partial
        println(fs(::f2, seq))      // normal
        println(fsf2(seq))          // partial
        println()
    }
}
