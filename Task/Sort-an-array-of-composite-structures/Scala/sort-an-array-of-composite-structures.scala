case class Pair(name:String, value:Double)
val input = Array(Pair("Krypton", 83.798), Pair("Beryllium", 9.012182), Pair("Silicon", 28.0855))
input.sortBy(_.name) // Array(Pair(Beryllium,9.012182), Pair(Krypton,83.798), Pair(Silicon,28.0855))

// alternative versions:
input.sortBy(struct => (struct.name, struct.value)) // additional sort field (name first, then value)
input.sortWith((a,b) => a.name.compareTo(b.name) < 0) // arbitrary comparison function
