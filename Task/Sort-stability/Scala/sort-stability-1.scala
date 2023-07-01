scala> val list = List((1, 'c'), (1, 'b'), (2, 'a'))
list: List[(Int, Char)] = List((1,c), (1,b), (2,a))

scala> val srt1 = list.sortWith(_._2 < _._2)
srt1: List[(Int, Char)] = List((2,a), (1,b), (1,c))

scala> val srt2 = srt1.sortBy(_._1) // Ordering[Int] is implicitly defined
srt2: List[(Int, Char)] = List((1,b), (1,c), (2,a))

scala> val cities = """
     | |UK  London
     | |US  New York
     | |US  Birmingham
     | |UK  Birmingham
     | |""".stripMargin.lines.filterNot(_ isEmpty).toSeq
cities: Seq[String] = ArrayBuffer(UK  London, US  New York, US  Birmingham, UK  Birmingham)

scala> cities.sortBy(_ substring 4)
res47: Seq[String] = ArrayBuffer(US  Birmingham, UK  Birmingham, UK  London, US  New York)
