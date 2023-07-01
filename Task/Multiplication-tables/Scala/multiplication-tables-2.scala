implicit def intToString(i: Int) = i.toString
val cell = (x:String) => print("%5s".format(x))

for {
  i <- 1 to 14
  j <- 1 to 14
}
yield {
  (i, j) match {
    case (i, 13) => cell("|")
    case (i, 14) if i > 12 => cell("\n")
    case (13, j) => cell("-----")
    case (i, 14) => cell(i + "\n")
    case (14, j) => cell(j)
    case (i, j) if i <= j => cell(i*j)
    case (i, j) => cell("-")
  }
}
