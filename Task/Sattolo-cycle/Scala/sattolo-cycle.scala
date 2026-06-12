def shuffle[T](a: Array[T]): Array[T] = {
  scala.util.Random.shuffle(a)
  a
}
