// version 1.1.3

import javax.xml.parsers.DocumentBuilderFactory
import org.xml.sax.InputSource
import java.io.StringReader
import org.w3c.dom.Node
import org.w3c.dom.Element

val xml =
"""
<Students>
    <Student Name="April" Gender="F" DateOfBirth="1989-01-02" />
    <Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />
    <Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />
    <Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">
        <Pet Type="dog" Name="Rover" />
    </Student>
    <Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" />
</Students>
"""

fun main(args: Array<String>) {
    val dbFactory = DocumentBuilderFactory.newInstance()
    val dBuilder  = dbFactory.newDocumentBuilder()
    val xmlInput = InputSource(StringReader(xml))
    val doc = dBuilder.parse(xmlInput)
    val nList = doc.getElementsByTagName("Student")
    for (i in 0 until nList.length) {
        val node = nList.item(i)
        if (node.nodeType == Node.ELEMENT_NODE) {
            val element = node as Element
            val name = element.getAttribute("Name")
            println(name)
        }
    }
}
