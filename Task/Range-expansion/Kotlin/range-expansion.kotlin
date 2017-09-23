// version 1.0.6

fun expandRange(s: String): MutableList<Int> {
    val list = mutableListOf<Int>()
    val items = s.split(',')
    var first: Int
    var last:  Int
    for (item in items) {
        val count = item.count { it == '-' }
        if (count == 0 || (count == 1 && item[0] == '-'))
            list.add(item.toInt())
        else {
            val items2 = item.split('-')
            if (count == 1) {
                first = items2[0].toInt()
                last  = items2[1].toInt()
            }
            else if (count == 2) {
                first = items2[1].toInt() * -1
                last  = items2[2].toInt()
            }
            else {
                first = items2[1].toInt() * -1
                last  = items2[3].toInt() * -1
            }
            for (i in first..last) list.add(i)
        }
    }
    return list
}

fun main(args: Array<String>) {
    val s = "-6,-3--1,3-5,7-11,14,15,17-20"
    println(expandRange(s))
}
