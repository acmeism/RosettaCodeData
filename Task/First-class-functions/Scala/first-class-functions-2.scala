class SweetFunction[B,C](f: B => C) {
  def o[A](g: A => B) = (x: A) => f(g(x))
}
implicit def sugarOnTop[A,B](f: A => B) = new SweetFunction(f)

// now functions can be composed thus
println((cube o cube o cuberoot)(0.5))
