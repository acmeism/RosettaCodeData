class Rational(n: Long, d:Long) extends Ordered[Rational]
{
   require(d!=0)
   private val g:Long = gcd(n, d)
   val numerator:Long = n/g
   val denominator:Long = d/g

   def this(n:Long)=this(n,1)

   def +(that:Rational):Rational=new Rational(
      numerator*that.denominator + that.numerator*denominator,
      denominator*that.denominator)

   def -(that:Rational):Rational=new Rational(
      numerator*that.denominator - that.numerator*denominator,
      denominator*that.denominator)

   def *(that:Rational):Rational=
      new Rational(numerator*that.numerator, denominator*that.denominator)

   def /(that:Rational):Rational=
      new Rational(numerator*that.denominator, that.numerator*denominator)

   def unary_~ :Rational=new Rational(denominator, numerator)

   def unary_- :Rational=new Rational(-numerator, denominator)

   def abs :Rational=new Rational(Math.abs(numerator), Math.abs(denominator))

   override def compare(that:Rational):Int=
      (this.numerator*that.denominator-that.numerator*this.denominator).toInt

   override def toString()=numerator+"/"+denominator

   private def gcd(x:Long, y:Long):Long=
      if(y==0) x else gcd(y, x%y)
}

object Rational
{
   def apply(n: Long, d:Long)=new Rational(n,d)
   def apply(n:Long)=new Rational(n)
   implicit def longToRational(i:Long)=new Rational(i)
}
