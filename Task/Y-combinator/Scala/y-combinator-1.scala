def Y[A,B](f: (A=>B)=>(A=>B)) = {
  case class W(wf: W=>A=>B) {
    def apply(w: W) = wf(w)
  }
  val g: W=>A=>B = w => f(w(w))(_)
  g(W(g))
}
