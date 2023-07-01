class Composable[A](f: A => A) {
  def o (g: A => A) = compose(f, g)
}

implicit def toComposable[A](f: A => A) = new Composable(f)

val add3 = (add1 _) o add2
