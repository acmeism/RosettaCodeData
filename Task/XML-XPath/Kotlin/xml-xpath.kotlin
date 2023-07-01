// version 1.1.3

import javax.xml.parsers.DocumentBuilderFactory
import org.xml.sax.InputSource
import java.io.StringReader
import javax.xml.xpath.XPathFactory
import javax.xml.xpath.XPathConstants
import org.w3c.dom.Node
import org.w3c.dom.NodeList

val xml =
"""
<inventory title="OmniCorp Store #45x10^3">
  <section name="health">
    <item upc="123456789" stock="12">
      <name>Invisibility Cream</name>
      <price>14.50</price>
      <description>Makes you invisible</description>
    </item>
    <item upc="445322344" stock="18">
      <name>Levitation Salve</name>
      <price>23.99</price>
      <description>Levitate yourself for up to 3 hours per application</description>
    </item>
  </section>
  <section name="food">
    <item upc="485672034" stock="653">
      <name>Blork and Freen Instameal</name>
      <price>4.95</price>
      <description>A tasty meal in a tablet; just add water</description>
    </item>
    <item upc="132957764" stock="44">
      <name>Grob winglets</name>
      <price>3.56</price>
      <description>Tender winglets of Grob. Just add water</description>
    </item>
  </section>
</inventory>
"""

fun main(args: Array<String>) {
    val dbFactory = DocumentBuilderFactory.newInstance()
    val dBuilder  = dbFactory.newDocumentBuilder()
    val xmlInput = InputSource(StringReader(xml))
    val doc = dBuilder.parse(xmlInput)
    val xpFactory = XPathFactory.newInstance()
    val xPath = xpFactory.newXPath()

    val qNode = xPath.evaluate("/inventory/section/item[1]", doc, XPathConstants.NODE) as Node
    val upc = qNode.attributes.getNamedItem("upc")
    val stock = qNode.attributes.getNamedItem("stock")
    println("For the first item :  upc = ${upc.textContent} and stock = ${stock.textContent}")

    val qNodes = xPath.evaluate("/inventory/section/item/price", doc, XPathConstants.NODESET) as NodeList
    print("\nThe prices of each item are : ")
    for (i in 0 until qNodes.length) print("${qNodes.item(i).textContent}  ")
    println()

    val qNodes2 = xPath.evaluate("/inventory/section/item/name", doc, XPathConstants.NODESET) as NodeList
    val names = Array<String>(qNodes2.length) { qNodes2.item(it).textContent }
    println("\nThe names of each item are as follows :")
    println("  ${names.joinToString("\n  ")}")
}
