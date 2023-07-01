def pad(s:String, i:Int, d:String) = {
  val padsize = (i-s.length).max(0)
  d match {
    case "left" => s+" "*padsize
    case "right" => " "*padsize+s
    case "center" => " "*(padsize/2) + s + " "*(padsize-padsize/2)
  }
}

val lines = scala.io.Source.fromFile("c:\\text.txt").getLines.map(_.trim())
val words = lines.map(_.split("\\$").toList).toList
val lens = words.map(l => l.map(_.length)).toList

var maxlens = Map[Int,Int]() withDefaultValue 0
lens foreach (l =>
  for(i <- (0 until l.length)){
    maxlens += i -> l(i).max(maxlens(i))
  }
)

val padded = words map ( _.zipWithIndex.map{case(s,i)=>pad(s,maxlens(i),"center")+" "} )
padded map (_.reduceLeft(_ + _)) foreach println
