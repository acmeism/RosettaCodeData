def order[T](input: Seq[T], using: Seq[T], used: Seq[T] = Seq()): Seq[T] =
  if (input.isEmpty || used.size >= using.size) input
  else if (using diff used contains input.head)
    using(used.size) +: order(input.tail, using, used :+ input.head)
  else input.head +: order(input.tail, using, used)
