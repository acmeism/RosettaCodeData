import scala.collection.MapView
import scala.math.pow

implicit class Pairs[A, B]( p:List[(A, B)]) {
  def collectPairs: MapView[A, List[B]] = p.groupBy(_._1).view.mapValues(_.map(_._2)).filterNot(_._2.size<2)
}

// Make a sorted List of Taxi Cab Numbers. Limit it to the cube of 1200 because we know it's high enough.
val taxiNums = {
  (1 to 1200).toList            // Start with a sequential list of integers
    .combinations(2).toList     // Find all two number combinations
    .map {
      case a :: b :: nil => ((pow(a, 3) + pow(b, 3)).toInt, (a, b))
      case _ => 0 ->(0, 0)
    }                           // Turn the list into the sum of two cubes and
    //      remember what we started with, eg. 28->(1,3)
    .collectPairs               // Only keep taxi cab numbers with a duplicate
    .toList.sortBy(_._1)        // Sort the results
}

def output() : Unit = {
  println( "%20s".format( "Taxi Cab Numbers" ) )
  println( "%20s%15s%15s".format( "-"*20, "-"*15, "-"*15 ) )

  taxiNums.take(25) foreach {
    case (p, a::b::Nil) => println( "%20d\t(%d\u00b3 + %d\u00b3)\t\t(%d\u00b3 + %d\u00b3)".format(p,a._1,a._2,b._1,b._2) )
  }

  taxiNums.slice(1999,2007) foreach {
    case (p, a::b::Nil) => println( "%20d\t(%d\u00b3 + %d\u00b3)\t(%d\u00b3 + %d\u00b3)".format(p,a._1,a._2,b._1,b._2) )
  }
}
