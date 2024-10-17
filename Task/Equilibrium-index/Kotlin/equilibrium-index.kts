// version 1.1

fun equilibriumIndices(a: IntArray): MutableList<Int> {
   val ei = mutableListOf<Int>()
   if (a.isEmpty()) return ei // empty list
   val sumAll  = a.sumBy { it }
   var sumLeft = 0
   var sumRight: Int
   for (i in 0 until a.size) {
       sumRight = sumAll - sumLeft - a[i]
       if (sumLeft == sumRight) ei.add(i)
       sumLeft += a[i]
   }
   return ei
}

fun main(args: Array<String>) {
    val a = intArrayOf(-7, 1, 5, 2, -4, 3, 0)
    val ei = equilibriumIndices(a)
    when (ei.size) {
         0     -> println("There are no equilibrium indices")
         1     -> println("The only equilibrium index is : ${ei[0]}")
         else  -> println("The equilibrium indices are : ${ei.joinToString(", ")}")
    }
}
