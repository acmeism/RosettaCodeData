import java.awt.Desktop
import java.io.{IOException, PrintWriter}
import java.net.{URI, ServerSocket}
import scala.xml.Elem

class WebServer(port: Int, soleDocument: Elem) extends Thread {
  this.setName(s"Server at $port")

  override def run() {
    val listener = try {
      new ServerSocket(port)
    } catch {
      case e: java.net.BindException => throw new IllegalStateException(s"Port $port already taken!")
    }
    println(s"Listening on port ${listener.getLocalPort}")

    while (!Thread.interrupted()) {
      try {
        //print(".")
        val socket = listener.accept
        new PrintWriter(socket.getOutputStream, true).println(soleDocument)
        socket.close()
      } catch {
        case ioe: IOException => println(ioe)
      }
    }
  }
} // class WebServer

object HtmlServer extends App {
  val PORT = 64507
  // Main
  val thread = new WebServer(PORT, HtmlBuilder)
  val uri = URI.create(s"http://localhost:$PORT/")
  thread.start()

  def HtmlBuilder: Elem = {
    def adressen: Iterator[String] =
      """Plataanstraat 5
        |Straat 12
        |Straat 12 II
        |Straat 1940 II
        |Dr. J. Straat   40
        |Dr. J. Straat 12 a
        |Dr. J. Straat 12-14
        |Laan 1940 – 1945 37
        |Plein 1940 2
        |1213-laan 11
        |16 april 1944 Pad 1
        |1e Kruisweg 36
        |Laan 1940-’45 66
        |Laan ’40-’45
        |Langeloërduinen 3 46
        |Marienwaerdt 2e Dreef 2
        |Provincialeweg N205 1
        |Rivium 2e Straat 59.
        |Nieuwe gracht 20rd
        |Nieuwe gracht 20rd 2
        |Nieuwe gracht 20zw /2
        |Nieuwe gracht 20zw/3
        |Nieuwe gracht 20 zw/4
        |Bahnhofstr. 4
        |Wertstr. 10
        |Lindenhof 1
        |Nordesch 20
        |Weilstr. 6
        |Harthauer Weg 2
        |Mainaustr. 49
        |August-Horch-Str. 3
        |Marktplatz 31
        |Schmidener Weg 3
        |Karl-Weysser-Str. 6""".stripMargin.lines

    def getSplittedAddresses(addresses: Iterator[String]) = {
      val extractor = new scala.util.matching.Regex( """(\s\d+[-/]\d+)|(\s(?!1940|1945)\d+[a-zI. /]*\d*)$|\d+\['][40|45]$""")


      def splitsAdres(input: String): (String, String) =
        (extractor.split(input).mkString, extractor.findFirstIn(input).getOrElse(""))

      addresses.map(org => {
        val temp = splitsAdres(org)
        List(org, temp._1, temp._2)
      })
    }

    def generateTable: Elem = {

      def coloring(rownum: Any): String = {
        rownum match {
          case Nil => "#9bbb59"
          case n: Int => if (n % 2 == 0) "#ebf1de" else "#d8e4bc"
        }
      }

      <table border="10">
        {(List(List("Given Address", "Street", "House Number")) ++ getSplittedAddresses(adressen)).
        zipWithIndex.map { case (row, rownum) => (if (rownum == 0) Nil else rownum) +: row}.map(row =>
        <tr bgcolor={coloring(row.head)}>
          {row.map(cell =>
          if (row.head == Nil)
            <th>
              {cell}
            </th>
          else
            <td>
              {cell}
            </td>)}
        </tr>)}
      </table>
    } // def generateTable

    <html>
      <head>
        <title>Rosetta.org Task solution</title>
      </head>
      <body lang="en-US" bgcolor="#e6e6ff" dir="LTR">
        <p align="CENTER">
          <font face="Arial, sans-serif" size="5">Split the house number from the street name</font>
        </p>
        <p align="CENTER">
          {generateTable}
        </p>
      </body>
    </html>
  } // def content
  if (Desktop.isDesktopSupported && Desktop.getDesktop.isSupported(Desktop.Action.BROWSE))
    Desktop.getDesktop.browse(uri)
  else println(s"Automatic start of Web browser not possible.\nWeb browser must be started manually, use $uri.")

  if (!thread.isAlive) sys.exit(-1)
  println("Web server started.")
  do print("Do you want to shutdown this server? <Y(es)/N>: ") while (!scala.io.StdIn.readBoolean)
  sys.exit()
}
