import scala.xml.Utility

 val header =
 """
<head>
<title>Csv2Html</title>
<style type="text/css">
td {background-color:#ddddff; }
thead td {background-color:#ddffdd; text-align:center; }
</style>
</head>
 """

def csv2html(csv:String, withHead:Boolean) = {

    def processRow =  "<tr>" ++  (_:String).split(',').flatMap("<td>" + Utility.escape(_) + "</td>") ++ "</tr>"

    val (first::rest)  = csv.lines.toList

    val tableHead = if (withHead) s"<thead>${processRow(first)}</thead>\n" else processRow(first)

    val tableContent =  tableHead + rest.map(processRow).mkString("\n")

    s"<html>$header<body><table>$tableContent</table></body></html>"
}

  val csv =
"""Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!"""

csv2html(csv, true)
