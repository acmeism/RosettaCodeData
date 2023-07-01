val src = io.Source fromURL "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
val vls = src.getLines.toList.groupBy(_.sorted).values
val max = vls.map(_.size).max
vls filter (_.size == max) map (_ mkString " ") mkString "\n"
