case class Point( x:Int,y:Int ) { override def toString = "(" + x + "," + y + ")" }

case class Polygon( pp:List[Point] ) {
  require( pp.size > 2, "A Polygon must consist of more than two points" )

  override def toString = "Polygon(" + pp.mkString(" ", ", ", " ") + ")"

  def area = {

    // Calculate using the Shoelace Formula
    val xx = pp.map( p => p.x )
    val yy = pp.map( p => p.y )
    val overlace = xx zip yy.drop(1)++yy.take(1)
    val underlace = yy zip xx.drop(1)++xx.take(1)

    (overlace.map( t => t._1 * t._2 ).sum - underlace.map( t => t._1 * t._2 ).sum).abs / 2.0
  }
}

// A little test...
{
val p = Polygon( List( Point(3,4), Point(5,11), Point(12,8), Point(9,5), Point(5,6) ) )

assert( p.area == 30.0 )

println( "Area of " + p + " = " + p.area )
}
