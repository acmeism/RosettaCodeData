/** Roll our own pared-down BigFraction class just for these Bernoulli Numbers */
case class BFraction( numerator:BigInt, denominator:BigInt ) {
  require( denominator != BigInt(0), "Denominator cannot be zero" )

  val gcd = numerator.gcd(denominator)

  val num = numerator / gcd
  val den = denominator / gcd

  def unary_- = BFraction(-num, den)
  def -( that:BFraction ) = that match {
    case f if f.num == BigInt(0) => this
    case f if f.den == this.den => BFraction(this.num - f.num, this.den)
    case f => BFraction(((this.num * f.den) - (f.num * this.den)), this.den * f.den )
  }

  def *( that:Int ) = BFraction( num * that, den )

  override def toString = num + " / " + den
}


def bernoulliB( n:Int ) : BFraction = {

  val aa : Array[BFraction] = Array.ofDim(n+1)

  for( m <- 0 to n ) {
    aa(m) = BFraction(1,(m+1))

    for( n <- m to 1 by -1 ) {
      aa(n-1) = (aa(n-1) - aa(n)) * n
    }
  }

  aa(0)
}

assert( {val b12 = bernoulliB(12); b12.num == -691 && b12.den == 2730 } )

val r = for( n <- 0 to 60; b = bernoulliB(n) if b.num != 0 ) yield (n, b)

val numeratorSize = r.map(_._2.num.toString.length).max

// Print the results
r foreach{ case (i,b) => {
  val label = f"b($i)"
  val num = (" " * (numeratorSize - b.num.toString.length)) + b.num
  println( f"$label%-6s $num / ${b.den}" )
}}
