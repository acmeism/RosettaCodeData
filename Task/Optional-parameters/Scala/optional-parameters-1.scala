  def sortTable(data: List[List[String]],
                ordering: (String, String) => Boolean = (_ < _),
                column: Int = 0,
                reverse: Boolean = false) = {
    val result = data.sortWith((a, b) => ordering(a(column), b(column)))
    if (reverse) result.reverse else result
  }
