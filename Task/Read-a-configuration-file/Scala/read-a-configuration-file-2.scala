for ((k,v) <- conf) {
  if (v.size == 1)
    println("%s: %s" format (k, v(0)))
  else
    for (i <- 0 until v.size)
      println("%s(%s): %s" format (k, i+1, v(i)))

}
