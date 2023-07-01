// version 1.1.3

import javax.xml.parsers.DocumentBuilderFactory
import javax.xml.transform.dom.DOMSource
import java.io.StringWriter
import javax.xml.transform.stream.StreamResult
import javax.xml.transform.TransformerFactory

fun main(args: Array<String>) {
    val names = listOf("April", "Tam O'Shanter", "Emily")

    val remarks = listOf(
        "Bubbly: I'm > Tam and <= Emily",
        "Burns: \"When chapman billies leave the street ...\"",
        "Short & shrift"
    )

    val dbFactory = DocumentBuilderFactory.newInstance()
    val dBuilder  = dbFactory.newDocumentBuilder()
    val doc = dBuilder.newDocument()
    val root = doc.createElement("CharacterRemarks") // create root node
    doc.appendChild(root)

    // now create Character elements
    for (i in 0 until names.size) {
        val character = doc.createElement("Character")
        character.setAttribute("name", names[i])
        val remark = doc.createTextNode(remarks[i])
        character.appendChild(remark)
        root.appendChild(character)
    }

    val source = DOMSource(doc)
    val sw = StringWriter()
    val result = StreamResult(sw)
    val tFactory = TransformerFactory.newInstance()
    tFactory.newTransformer().apply {
        setOutputProperty("omit-xml-declaration", "yes")
        setOutputProperty("indent", "yes")
        setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4")
        transform(source, result)
    }
    println(sw)
}
