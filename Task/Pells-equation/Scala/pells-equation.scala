def pellFermat(n: Int): (BigInt,BigInt) = {
  import scala.math.{sqrt, floor}

  val x = BigInt(floor(sqrt(n)).toInt)

  var i = 0

  // Use the Continued Fractions method
  def converge(y:BigInt, z:BigInt, r:BigInt, e1:BigInt, e2:BigInt, f1:BigInt, f2:BigInt ) : (BigInt,BigInt) = {

    val a = f2 * x + e2
    val b = f2

    if (a * a - n * b * b == 1) {
      return (a, b)
    }

    val yh = r * z - y
    val zh = (n - yh * yh) / z
    val rh = (x + yh) / zh

    converge(yh,zh,rh,e2,e1 + e2 * rh,f2,f1 + f2 * rh)
  }

  converge(x,BigInt("1"),x << 1,BigInt("1"),BigInt("0"),BigInt("0"),BigInt("1"))
}

val nums = List(61,109,181,277)
val solutions = nums.map{pellFermat(_)}

{
  println("For Pell's Equation, x\u00b2 - ny\u00b2 = 1\n")
  (nums zip solutions).foreach{ case (n, (x,y)) => println(s"n = $n, x = $x, y = $y")}
}
