scala> // Immutable collections do not change the original object
scala> // A List
scala> val list = Nil // Empty List
list: scala.collection.immutable.Nil.type = List()
scala> val list2 = List(1, 2) // List with two elements
list2: List[Int] = List(1, 2)
scala> val list3 = 3 :: list2 // prepend 3 to list2, using a special operator
list3: List[Int] = List(3, 1, 2)
scala> // A Set
scala> val set = Set.empty[Char] // Empty Set of Char type
set: scala.collection.immutable.Set[Char] = Set()
scala> val set1 = set + 'c' // add an element
set1: scala.collection.immutable.Set[Char] = Set(c)
scala> // A Map
scala> val map = Map(1 -> "A")
map: scala.collection.immutable.Map[Int,java.lang.String] = Map(1 -> A)
scala> val map1 = map + (2 -> "Map")
map1: scala.collection.immutable.Map[Int,java.lang.String] = Map(1 -> A, 2 -> Map)
scala> // Mutable collections can be modified
scala> val queue = new scala.collection.mutable.Queue[Int]
queue: scala.collection.mutable.Queue[Int] = Queue()
scala> queue += 4
res0: queue.type = Queue(4)
scala> queue += 5
res1: queue.type = Queue(4, 5)
scala> queue
res2: scala.collection.mutable.Queue[Int] = Queue(4, 5)
scala> val set = scala.collection.mutable.Set('a')
set: scala.collection.mutable.Set[Char] = Set(a)
scala> set += 'b'
res3: set.type = Set(b, a)
scala> val map = scala.collection.mutable.Map(1 -> "one")
map: scala.collection.mutable.Map[Int,java.lang.String] = Map(1 -> one)
scala> map += (2 -> "two")
res4: map.type = Map(2 -> two, 1 -> one)
scala> map
res5: scala.collection.mutable.Map[Int,java.lang.String] = Map(2 -> two, 1 -> one)
