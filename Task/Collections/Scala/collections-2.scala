    import collection.concurrent.TrieMap

    // super concurrent mutable hashmap
    val map = TrieMap("Amsterdam" -> "Netherlands",
      "New York" -> "USA",
      "Heemstede" -> "Netherlands")

    map("Laussanne") = "Switzerland" // 2 Ways of updating
    map += ("Tokio" -> "Japan")

    assert(map("New York") == "USA")
    assert(!map.isDefinedAt("Gent")) // isDefinedAt is false
    assert(map.isDefinedAt("Laussanne")) // true

    val hash = new TrieMap[Int, Int]
    hash(1) = 2
    hash += (1 -> 2) // same as hash(1) = 2
    hash += (3 -> 4, 5 -> 6, 44 -> 99)
    hash(44) // 99
    hash.contains(33) // false
    hash.isDefinedAt(33) // same as contains
    hash.contains(44) // true
    // iterate over key/value
    //    hash.foreach { case (key, val) => println(  "key " + e._1 + " value " + e._2) } // e is a 2 element Tuple
    // same with for syntax
    for ((k, v) <- hash) println("key " + k + " value " + v)
    //    // items in map where the key is greater than 3
        map.filter { k => k._1 > 3 } //  Map(5 -> 6, 44 -> 99)
    //    // same with for syntax
        for ((k, v) <- map; if k > 3) yield (k, v)
