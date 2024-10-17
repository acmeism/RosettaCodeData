// version 1.1.3

import javax.xml.parsers.DocumentBuilderFactory
import javax.xml.transform.dom.DOMSource
import java.io.StringWriter
import javax.xml.transform.stream.StreamResult
import javax.xml.transform.TransformerFactory

fun main(args: Array<String>) {
    val dbFactory = DocumentBuilderFactory.newInstance()
    val dBuilder  = dbFactory.newDocumentBuilder()
    val doc = dBuilder.newDocument()
    val root = doc.createElement("root")  // create root node
    doc.appendChild(root)
    val element = doc.createElement("element")  // create element node
    val text = doc.createTextNode("Some text here")  // create text node
    element.appendChild(text)
    root.appendChild(element)

    // serialize
    val source = DOMSource(doc)
    val sw = StringWriter()
    val result = StreamResult(sw)
    val tFactory = TransformerFactory.newInstance()
    tFactory.newTransformer().apply {
        setOutputProperty("indent", "yes")
        setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4")
        transform(source, result)
    }
    println(sw)
}
