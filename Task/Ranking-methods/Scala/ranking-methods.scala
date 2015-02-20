object RankingMethods extends App {
    case class Score(score: Int, name: String) // incoming data
    case class Rank[Precision](rank: Precision, names: List[String]) // outgoing results (can be int or double)
    case class State[Precision](n: Int, done: List[Rank[Precision]]) { // internal state, no mutable variables
        def next(n: Int, next: Rank[Precision]) = State(n, next :: done)
    }
    def grouped[Precision](list: List[Score]) = // group names together by score, with highest first
        (scala.collection.immutable.TreeMap[Int, List[Score]]() ++ list.groupBy(-_.score))
        .values.map(_.map(_.name)).foldLeft(State[Precision](1, Nil)) _

    // Ranking methods:

    def rankStandard(list: List[Score]) =
        grouped[Int](list){case (state, names) => state.next(state.n+names.length, Rank(state.n, names))}.done.reverse

    def rankModified(list: List[Score]) =
        rankStandard(list).map(r => Rank(r.rank+r.names.length-1, r.names))

    def rankDense(list: List[Score]) =
        grouped[Int](list){case (state, names) => state.next(state.n+1, Rank(state.n, names))}.done.reverse

    def rankOrdinal(list: List[Score]) =
        list.zipWithIndex.map{case (score, n) => Rank(n+1, List(score.name))}

    def rankFractional(list: List[Score]) =
        rankStandard(list).map(r => Rank((2*r.rank+r.names.length-1.0)/2, r.names))

    // Tests:

    def parseScores(s: String) = s split "\\s+" match {case Array(s,n) => Score(s.toInt, n)}
    val test = List("44 Solomon", "42 Jason", "42 Errol", "41 Garry", "41 Bernard", "41 Barry", "39 Stephen").map(parseScores)

    println("Standard:")
    println(rankStandard(test) mkString "\n")
    println("\nModified:")
    println(rankModified(test) mkString "\n")
    println("\nDense:")
    println(rankDense(test) mkString "\n")
    println("\nOrdinal:")
    println(rankOrdinal(test) mkString "\n")
    println("\nFractional:")
    println(rankFractional(test) mkString "\n")

}
