// mutable maps (HashSets)
import scala.collection.mutable.HashMap
val hash = new HashMap[Int, Int]
hash(1) = 2
hash += (1 -> 2)  // same as hash(1) = 2
hash += (3 -> 4, 5 -> 6, 44 -> 99)
hash(44) // 99
hash.contains(33) // false
hash.isDefinedAt(33) // same as contains
hash.contains(44) // true
