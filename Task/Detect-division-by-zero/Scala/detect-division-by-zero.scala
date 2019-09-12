object DivideByZero extends Application {

  def check(x: Int, y: Int): Boolean = {
    try {
      val result = x / y
      println(result)
      return false
    } catch {
      case x: ArithmeticException => {
        return true
      }
    }
  }

  println("divided by zero = " + check(1, 0))

  def check1(x: Int, y: Int): Boolean = {
    import scala.util.Try
    Try(y/x).isFailure
  }
  println("divided by zero = " + check1(1, 0))

}
