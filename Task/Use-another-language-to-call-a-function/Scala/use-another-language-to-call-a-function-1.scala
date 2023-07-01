/* Query.scala */
object Query {
  def call(data: Array[Byte], length: Array[Int]): Boolean = {
    val message = "Here am I"
    val mb = message.getBytes("utf-8")
    if (length(0) >= mb.length) {
      length(0) = mb.length
      System.arraycopy(mb, 0, data, 0, mb.length)
      true
    } else false
  }
}
