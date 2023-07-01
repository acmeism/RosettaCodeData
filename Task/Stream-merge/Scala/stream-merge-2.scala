val i1 = Iterator.tabulate(5) { i =>
  val x = i * 3
  println(s"generating $x")
  x
}

val i2 = Iterator.tabulate(5) { i =>
  val x = i * 3 + 1
  println(s"generating $x")
  x
}

val i3 = Iterator.tabulate(5) { i =>
  val x = i * 3 + 2
  println(s"generating $x")
  x
}

val merged = mergeN(i1, i2, i3)

while (merged.hasNext) {
  val x = merged.next
  println(s"output: $x")
}
