def join[Type](left: Seq[Seq[Type]], right: Seq[Seq[Type]]) = {
    val hash = right.groupBy(_.head) withDefaultValue Seq()
    left.flatMap(cols => hash(cols.last).map(cols ++ _.tail))
}

// Example:

val table1 = List(List("27", "Jonah"),
                  List("18", "Alan"),
                  List("28", "Glory"),
                  List("18", "Popeye"),
                  List("28", "Alan"))
val table2 = List(List("Jonah", "Whales"),
                  List("Jonah", "Spiders"),
                  List("Alan", "Ghosts"),
                  List("Alan", "Zombies"),
                  List("Glory", "Buffy"))

println(join(table1, table2) mkString "\n")
