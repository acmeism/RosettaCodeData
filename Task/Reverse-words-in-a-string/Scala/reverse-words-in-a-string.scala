object ReverseWords extends App {

  """|  ---------- Ice and Fire ------------
     |
     |  fire, in end will world the say Some
     |  ice. in say Some
     |  desire of tasted I've what From
     |  fire. favor who those with hold I
     |
     |  ... elided paragraph last ...
     |
     |  Frost Robert -----------------------  """
    .stripMargin.lines.toList.map{_.split(" ")}.map{_.reverse}
    .map(_.mkString(" "))
    .foreach{println}

}
