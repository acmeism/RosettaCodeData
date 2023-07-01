object SetConsolidation extends App {
    def consolidate[Type](sets: Set[Set[Type]]): Set[Set[Type]] = {
        var result = sets // each iteration combines two sets and reiterates, else returns
        for (i <- sets; j <- sets - i; k = i.intersect(j);
            if result == sets && k.nonEmpty) result = result - i - j + i.union(j)
        if (result == sets) sets else consolidate(result)
    }

    // Tests:
    def parse(s: String) =
        s.split(",").map(_.split("").toSet).toSet
    def pretty[Type](sets: Set[Set[Type]]) =
        sets.map(_.mkString("{",",","}")).mkString(" ")
    val tests = List(
        parse("AB,CD") -> Set(Set("A", "B"), Set("C", "D")),
        parse("AB,BD") -> Set(Set("A", "B", "D")),
        parse("AB,CD,DB") -> Set(Set("A", "B", "C", "D")),
        parse("HIK,AB,CD,DB,FGH") -> Set(Set("A", "B", "C", "D"), Set("F", "G", "H", "I", "K"))
    )
    require(Set("A", "B", "C", "D") == Set("B", "C", "A", "D"))
    assert(tests.forall{case (test, expect) =>
        val result = consolidate(test)
        println(s"${pretty(test)} -> ${pretty(result)}")
        expect == result
    })

}
