// version 1.2.10

class MList<T : Any> private constructor(val value: List<T>) {
    fun <U : Any> bind(f: (List<T>) -> MList<U>) = f(this.value)

    companion object {
        fun <T : Any> unit(lt: List<T>) = MList<T>(lt)
    }
}

fun doubler(li: List<Int>) = MList.unit(li.map { 2 * it } )

fun letters(li: List<Int>) = MList.unit(li.map { "${('@' + it)}".repeat(it) } )

fun main(args: Array<String>) {
    val iv = MList.unit(listOf(2, 3, 4))
    val fv = iv.bind(::doubler).bind(::letters)
    println(fv.value)
}
