object TokenizeStringWithEscaping0 extends App {

  val (markerSpE,markerSpF) = ("\ufffe" , "\uffff")

  def tokenize(str: String, sep: String, esc: String): Array[String] = {

    val s0 = str.replace( esc + esc, markerSpE).replace(esc + sep, markerSpF)
    val s = if (s0.last.toString == esc) s0.replace(esc, "") + esc else s0.replace(esc, "")
    s.split(sep.head).map (_.replace(markerSpE, esc).replace(markerSpF, sep))
  }

  def str = "one^|uno||three^^^^|four^^^|^cuatro|"

  tokenize(str, "|", "^").foreach(it => println(if (it.isEmpty) "<empty token>" else it))
}
