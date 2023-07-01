object PhraseReversals extends App {
    val phrase = scala.io.StdIn.readLine
    println(phrase.reverse)
    println(phrase.split(' ').map(_.reverse).mkString(" "))
    println(phrase.split(' ').reverse.mkString(" "))
}
