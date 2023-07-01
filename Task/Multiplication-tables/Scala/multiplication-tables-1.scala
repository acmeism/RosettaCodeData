//Multiplication Table
print("%5s".format("|"))
for (i <- 1 to 12) print("%5d".format(i))
println()
println("-----" * 13)

for (i <- 1 to 12) {
  print("%4d|".format(i))

  for (j <- 1 to 12) {
    if (i <= j)
      print("%5d".format(i * j))
    else
      print("%5s".format(""))
  }

  println("")
}
