val longest = scala.io.Source.fromFile(args.head).getLines.toIterable.groupBy(_.length).max._2
println(longest mkString "\n")
