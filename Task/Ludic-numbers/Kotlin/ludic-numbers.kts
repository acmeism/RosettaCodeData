// version 1.0.6

/* Rather than remove elements from a MutableList which would be a relatively expensive operation
   we instead use two arrays:

   1. An array of the Ludic numbers to be returned.
   2. A 'working' array of a suitable size whose elements are set to 0 to denote removal. */

fun ludic(n: Int): IntArray {
    if (n < 1) return IntArray(0)
    val lu = IntArray(n)  // array of Ludic numbers required
    lu[0] = 1
    if (n == 1) return lu
    var count = 1
    var count2: Int
    var j: Int
    var k = 1
    var ub = n * 11  // big enough to deal with up to 2005 ludic numbers
    val a = IntArray(ub) { it }  // working array
    while (true) {
        k += 1
        for (i in k until ub) {
            if (a[i] > 0) {
                count +=1
                lu[count - 1] = a[i]
                if (n == count) return lu
                a[i] = 0
                k = i
                break
            }
        }
        count2 = 0
        j = k + 1
        while (j < ub) {
            if (a[j] > 0) {
                count2 +=1
                if (count2 == k) {
                    a[j] = 0
                    count2 = 0
                }
            }
            j += 1
        }
    }
}

fun main(args: Array<String>) {
    val lu: IntArray = ludic(2005)
    println("The first 25 Ludic numbers are :")
    for (i in 0 .. 24) print("%4d".format(lu[i]))

    val count = lu.count { it <= 1000 }
    println("\n\nThere are $count Ludic numbers <= 1000" )

    println("\nThe 2000th to 2005th Ludics are :")
    for (i in 1999 .. 2004) print("${lu[i]}  ")

    println("\n\nThe Ludic triplets below 250 are : ")
    var k: Int = 0
    var ldc: Int
    var b: Boolean
    for (i in 0 .. 247) {
        ldc = lu[i]
        if (ldc >= 244) break
        b = false
        for (j in i + 1 .. 248) {
             if (lu[j] == ldc + 2) {
                 b = true
                 k = j
                 break
             }
             else if (lu[j] > ldc + 2) break
        }
        if (!b) continue
        for (j in k + 1 .. 249) {
            if (lu[j] == ldc + 6) {
                println("($ldc, ${ldc + 2}, ${ldc + 6})")
                break
            }
            else if (lu[j] > ldc + 6) break
        }
    }
}
