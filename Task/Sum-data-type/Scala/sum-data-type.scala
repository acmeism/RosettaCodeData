case class Envelop[T](member: T)

val list = List(
  Envelop("a string"),
  Envelop(732), // an integer
  Envelop('☺'), // a character
  Envelop(true) // a boolean value
)

list.foreach { case Envelop(element) => println(element) }
