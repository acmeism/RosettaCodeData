object TableGenerator extends App {
  val data = List(List("X", "Y", "Z"), List(11, 12, 13), List(12, 22, 23), List(13, 32, 33))

  def generateTable(data: List[List[Any]]) = {
    <table>
      {data.zipWithIndex.map { case (row, rownum) => (if (rownum == 0) Nil else rownum) +: row}.
      map(row => <tr>
      {row.map(cell =>
        <td>
          {cell}
        </td>)}
    </tr>)}
    </table>
  }

  println(generateTable(data))
}
