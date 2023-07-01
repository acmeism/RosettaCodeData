object Eval extends App {

  def evalWithX(expr: String, a: Double, b: Double)=
    {val x = b; eval(expr)} - {val x = a; eval(expr)}

  println(evalWithX("Math.exp(x)", 0.0, 1.0))

}
