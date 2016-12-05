def multiFact(n : BigInt, degree : BigInt) = (n to 1 by -degree).product

for{
  degree <- 1 to 5
  str = (1 to 10).map(n => multiFact(n, degree)).mkString(" ")
} println(s"Degree $degree: $str")
