// version 1.0.5-2

fun main(args: Array<String>) {
    val array = arrayOf(1, 2, 3, 4, 5, 6, 7, 8, 9)
    println(array.joinToString(" "))

    val filteredArray = array.filter{ it % 2 == 0 }
    println(filteredArray.joinToString(" "))

    val mutableList = array.toMutableList()
    mutableList.retainAll { it % 2 == 0 }
    println(mutableList.joinToString(" "))
}
