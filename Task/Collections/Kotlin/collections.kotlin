import java.util.PriorityQueue

fun main(args: Array<String>) {
    // generic array
    val ga = arrayOf(1, 2, 3)
    println(ga.joinToString(prefix = "[", postfix = "]"))

    // specialized array (one for each primitive type)
    val da = doubleArrayOf(4.0, 5.0, 6.0)
    println(da.joinToString(prefix = "[", postfix = "]"))

    // immutable list
    val li = listOf<Byte>(7, 8, 9)
    println(li)

    // mutable list
    val ml = mutableListOf<Short>()
    ml.add(10); ml.add(11); ml.add(12)
    println(ml)

    // immutable map
    val hm = mapOf('a' to 97, 'b' to 98, 'c' to 99)
    println(hm)

    // mutable map
    val mm = mutableMapOf<Char, Int>()
    mm.put('d', 100); mm.put('e', 101); mm.put('f', 102)
    println(mm)

    // immutable set (duplicates not allowed)
    val se = setOf(1, 2, 3)
    println(se)

    // mutable set (duplicates not allowed)
    val ms = mutableSetOf<Long>()
    ms.add(4L); ms.add(5L); ms.add(6L)
    println(ms)

    // priority queue (imported from Java)
    val pq = PriorityQueue<String>()
    pq.add("First"); pq.add("Second"); pq.add("Third")
    println(pq)
}
