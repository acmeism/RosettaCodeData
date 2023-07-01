def logical(a: Boolean, b: Boolean): Unit = {
  println("and: " + (a && b))
  println("or:  " + (a || b))
  println("not: " + !a)
}

logical(true, false)
