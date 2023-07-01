import scala.collection.mutable.LinkedHashMap

val range = 1 to 10000
val maxIter = 500;

def lychrelSeq( seed:BigInt ) : Stream[BigInt] = {
  def reverse( v:BigInt ) = BigInt(v.toString.reverse)
  def isPalindromic( v:BigInt ) = { val s = (v + reverse(v)).toString; s == s.reverse }

  def loop( v:BigInt ):Stream[BigInt] = v #:: loop( v + reverse(v) )
  val seq = loop(seed)

  seq.take( seq.take(maxIter).indexWhere( isPalindromic(_) ) match {
    case -1 => maxIter
    case n => n + 1
  })
}

// A quick test
assert( lychrelSeq(56).length == 1 )
assert( lychrelSeq(57).length == 2 )
assert( lychrelSeq(59).length == 3 )
assert( lychrelSeq(89).length == 24 )
assert( lychrelSeq(10911).length == 55 )

val lychrelNums = for( n <- range if lychrelSeq(n).length == maxIter ) yield n

val (seeds,related) = {
  val lycs = LinkedHashMap[BigInt,Int]()

  // Fill the Map not allowing duplicate values
  lychrelNums.foreach{ n => val ll = lychrelSeq(n).map( (_ -> n) ); LinkedHashMap( ll:_* ) ++= lycs }

  for( n <- lychrelNums ) {
    val ll = lychrelSeq(n).map( (_ -> n) )
    val mm = LinkedHashMap( ll:_* )
    lycs ++= (mm ++= lycs)
  }

  // Group by the Lychrel Number
  val zz = lycs.groupBy{ _._2 }.map{ case (k,m) => k -> m.keys.toList.sorted }

  // Now, group by size, seeds will have 500 or maxIter
  val yy = lychrelNums.groupBy( n => zz.filterKeys(_==n).values.flatten.size < maxIter )

  // Results: seeds are false, related true
  (yy.filterKeys(_ == false).values.toVector.flatten,
   yy.filterKeys(_ ==  true).values.toVector.flatten)
}

val lychrelPals = for( n <- lychrelNums; if n.toString == n.toString.reverse ) yield n

// Show the results
{
println( s"There are ${lychrelNums.size} Lychrel Numbers between ${range.min} and ${range.max} \n   when limited to $maxIter iterations:" )
println
println( s"\t        Seeds: ${seeds.size} (${seeds.mkString(", ")})" )
println( s"\tRelated Count: ${related.size}" )
println( s"\t  Palindromes: (${lychrelPals.mkString(", ")})")
}
