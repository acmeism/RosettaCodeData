// version 1.0.6

fun main(args: Array<String>) {
   val fruits  = setOf("apple", "pear", "orange", "banana")
   println("fruits  : $fruits")
   val fruits2 = setOf("melon", "orange", "lemon", "gooseberry")
   println("fruits2 : $fruits2\n")

   println("fruits  contains 'banana'     : ${"banana" in fruits}")
   println("fruits2 contains 'elderberry' : ${"elderbury" in fruits2}\n")

   println("Union        : ${fruits.union(fruits2)}")
   println("Intersection : ${fruits.intersect(fruits2)}")
   println("Difference   : ${fruits.minus(fruits2)}\n")

   println("fruits2 is a subset of fruits : ${fruits.containsAll(fruits2)}\n")
   val fruits3 = fruits
   println("fruits3 : $fruits3\n")
   var areEqual = fruits.containsAll(fruits2) && fruits3.containsAll(fruits)
   println("fruits2 and fruits are equal  : $areEqual")
   areEqual = fruits.containsAll(fruits3) && fruits3.containsAll(fruits)
   println("fruits3 and fruits are equal  : $areEqual\n")

   val fruits4 = setOf("apple", "orange")
   println("fruits4 : $fruits4\n")
   var isProperSubset = fruits.containsAll(fruits3) && !fruits3.containsAll(fruits)
   println("fruits3 is a proper subset of fruits : $isProperSubset")
   isProperSubset = fruits.containsAll(fruits4) && !fruits4.containsAll(fruits)
   println("fruits4 is a proper subset of fruits : $isProperSubset\n")

   val fruits5 = mutableSetOf("cherry", "blueberry", "raspberry")
   println("fruits5 : $fruits5\n")
   fruits5 += "guava"
   println("fruits5 + 'guava'  : $fruits5")
   println("fruits5 - 'cherry' : ${fruits5 - "cherry"}")
}
