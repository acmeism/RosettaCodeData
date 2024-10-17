// version 1.0.6

const val NULL = "\u0000"

fun orderDisjointList(m: String, n: String): String {
    val nList = n.split(' ')
    // first replace the first occurrence of items of 'n' in 'm' with the NULL character
    // which we can safely assume won't occur in 'm' naturally
    var p = m
    for (item in nList) p = p.replaceFirst(item, NULL)
    // now successively replace the NULLs with items from nList
    val mList = p.split(NULL)
    val sb = StringBuilder()
    for (i in 0 until nList.size) sb.append(mList[i], nList[i])
    return sb.append(mList.last()).toString()
}

fun main(args: Array<String>) {
    val m = arrayOf(
        "the cat sat on the mat",
        "the cat sat on the mat",
        "A B C A B C A B C",
        "A B C A B D A B E",
        "A B",
        "A B",
        "A B B A"
    )
    val n = arrayOf(
        "mat cat",
        "cat mat",
        "C A C A",
        "E A D A",
        "B",
        "B A",
        "B A"
    )
    for (i in 0 until m.size)
        println("${m[i].padEnd(22)}  ->  ${n[i].padEnd(7)}  ->  ${orderDisjointList(m[i], n[i])}")
}
