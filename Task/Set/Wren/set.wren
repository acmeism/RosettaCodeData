import "./set" for Set

var fruits = Set.new(["apple", "pear", "orange", "banana"])
System.print("fruits  : %(fruits)")
var fruits2 = Set.new(["melon", "orange", "lemon", "gooseberry"])
System.print("fruits2 : %(fruits2)\n")

System.print("fruits  contains 'banana'     : %(fruits.contains("banana"))")
System.print("fruits2 contains 'elderberry' : %(fruits2.contains("elderberry"))\n")

System.print("Union        : %(fruits.union(fruits2))")
System.print("Intersection : %(fruits.intersect(fruits2))")
System.print("Difference   : %(fruits.except(fruits2))\n")

System.print("fruits2 is a subset of fruits : %(fruits2.subsetOf(fruits))\n")
var fruits3 = fruits.copy()
System.print("fruits3 : %(fruits3)\n")
System.print("fruits2 and fruits are equal  : %(fruits2 == fruits)")
System.print("fruits3 and fruits are equal  : %(fruits3 == fruits)\n")

var fruits4 = Set.new(["apple", "orange"])
System.print("fruits4 : %(fruits4)\n")
System.print("fruits3 is a proper subset of fruits : %(fruits3.properSubsetOf(fruits))")
System.print("fruits4 is a proper subset of fruits : %(fruits4.properSubsetOf(fruits))\n")

var fruits5 = Set.new(["cherry", "blueberry", "raspberry"])
System.print("fruits5 : %(fruits5)\n")
fruits5.add("guava")
System.print("fruits5 + 'guava'  : %(fruits5)")
fruits5.remove("cherry")
System.print("fruits5 - 'cherry' : %(fruits5)")
