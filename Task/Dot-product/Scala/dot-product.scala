class Dot[T](v1: Seq[T])(implicit n: Numeric[T]) {
  import n._
  def dot(v2: Seq[T]) = {
    require(v1.length == v2.length)
    v1 zip v2 map Function.tupled(_*_) sum
  }
}

implicit def toDot[T : Numeric](v1: Seq[T]) = new Dot(v1)
val v1 = List(1, 3, -5)
val v2 = List(4, -2, -1)
println(v1 dot v2)
