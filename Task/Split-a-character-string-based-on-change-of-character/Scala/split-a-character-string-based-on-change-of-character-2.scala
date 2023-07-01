def runLengthSplit(s:String):List[String] = {
  def recursiveSplit(acc:List[String], rest:String): List[String] = rest match {
    case "" => acc
    case _ => {
      val (h, t) = rest.span(_ == rest.head)
      recursiveSplit(acc :+ h, t)
    }
  }

  recursiveSplit(Nil, s)
}

val result = runLengthSplit("""gHHH5YY++///\""")
println(result.mkString(","))
