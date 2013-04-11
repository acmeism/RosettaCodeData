case class Quaternion(re:Double =0.0, i:Double =0.0, j:Double =0.0, k:Double =0.0) {
  lazy val im=(i, j, k)
  private lazy val norm2=re*re + i*i + j*j + k*k
  lazy val norm=math.sqrt(norm2)

  def negative=new Quaternion(-re, -i, -j, -k)
  def conjugate=new Quaternion(re, -i, -j, -k)
  def reciprocal=new Quaternion(re/norm2, -i/norm2, -j/norm2, -k/norm2)

  def +(q:Quaternion)=new Quaternion(re+q.re, i+q.i, j+q.j, k+q.k)
  def -(q:Quaternion)=new Quaternion(re-q.re, i-q.i, j-q.j, k-q.k)
  def *(q:Quaternion)=new Quaternion(
	 re*q.re - i*q.i - j*q.j - k*q.k,
	 re*q.i + i*q.re + j*q.k - k*q.j,
	 re*q.j - i*q.k + j*q.re + k*q.i,
	 re*q.k + i*q.j - j*q.i + k*q.re	
  )
  def /(q:Quaternion)=this*q.reciprocal

  def unary_- = negative
  def unary_~ = conjugate

  override def equals(x:Any):Boolean=x match {
		case Quaternion(re, i, j, k) => (Double.doubleToLongBits(this.re)==Double.doubleToLongBits(re)) &&
		  Double.doubleToLongBits(this.i)==Double.doubleToLongBits(i) &&
		  Double.doubleToLongBits(this.j)==Double.doubleToLongBits(j) &&
		  Double.doubleToLongBits(this.k)==Double.doubleToLongBits(k)
		case _ => false
	}

  override def toString()="Q(%.2f, %.2fi, %.2fj, %.2fk)".formatLocal(Locale.ENGLISH, re,i,j,k)
}

object Quaternion {
  implicit def number2Quaternion[T <% Number](n:T):Quaternion = apply(n.doubleValue)
}
