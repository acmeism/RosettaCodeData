def fizzbuzz(l: List[String], n: Int, s: String) = if (l.head.toInt % n == 0) l :+ s else l
def fizz(l: List[String]) = fizzbuzz(l, 3, "Fizz")
def buzz(l: List[String]) = fizzbuzz(l, 5, "Buzz")
def headOrTail(l: List[String]) = if (l.tail.size == 0) l.head else l.tail.mkString
Stream.from(1).take(100).map(n => List(n.toString)).map(fizz).map(buzz).map(headOrTail).foreach(println)
