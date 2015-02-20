object CsvToHTML extends App {
  val header = <head>
    <title>CsvToHTML</title>
    <style type="text/css">
      td {{background-color:#ddddff; }} thead td {{background-color:#ddffdd; text-align:center; }}
    </style>
  </head>
  val csv =
    """Character,Speech
      |The multitude,The messiah! Show us the messiah!
      |Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
      |The multitude,Who are you?
      |Brians mother,I'm his mother; that's who!
      |The multitude,Behold his mother! Behold his mother!""".stripMargin

  def csv2html(csv: String, withHead: Boolean) = {

    def processRow(text: String) = <tr>
      {text.split(',').map(s => <td>
        {s}
      </td>)}
    </tr>

    val (first :: rest) = csv.lines.toList // Separate the header and the rest

    def tableHead = if (withHead)
      <thead>
        {processRow(first)}
      </thead>
    else processRow(first)

    <html>
      {header}<body>
      <table>
        {tableHead}{rest.map(processRow)}
      </table>
    </body>
    </html>
  }

  println(csv2html(csv, true))
}
