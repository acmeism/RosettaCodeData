  def loop = new Iterator[Int] {
    var i = 1024
    def hasNext = i > 0
    def next(): Int = { val tmp = i; i = i / 2; tmp }
  }
  loop.foreach(println(_))
