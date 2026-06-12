case class Quaternion(re: Double = 0.0, i: Double = 0.0, j: Double = 0.0, k: Double = 0.0) {
  lazy val im = (i, j, k)
  private lazy val norm2 = re*re + i*i + j*j + k*k
  lazy val norm = math.sqrt(norm2)

  def negative = Quaternion(-re, -i, -j, -k)
  def conjugate = Quaternion(re, -i, -j, -k)
  def reciprocal = Quaternion(re/norm2, -i/norm2, -j/norm2, -k/norm2)

  def +(q: Quaternion) = Quaternion(re+q.re, i+q.i, j+q.j, k+q.k)
  def -(q: Quaternion) = Quaternion(re-q.re, i-q.i, j-q.j, k-q.k)
  def *(q: Quaternion) = Quaternion(
	 re*q.re - i*q.i - j*q.j - k*q.k,
	 re*q.i + i*q.re + j*q.k - k*q.j,
	 re*q.j - i*q.k + j*q.re + k*q.i,
	 re*q.k + i*q.j - j*q.i + k*q.re	
  )
  def /(q: Quaternion) = this * q.reciprocal

  def unary_- = negative
  def unary_~ = conjugate

  override def toString = "Q(%.2f, %.2fi, %.2fj, %.2fk)".formatLocal(java.util.Locale.ENGLISH, re, i, j, k)
}

object Quaternion {
  import scala.language.implicitConversions
  import Numeric.Implicits._

  implicit def number2Quaternion[T:Numeric](n: T) = Quaternion(n.toDouble)
}
