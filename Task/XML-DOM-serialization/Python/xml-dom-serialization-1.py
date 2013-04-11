from xml.dom.minidom import getDOMImplementation

dom = getDOMImplementation()
document = dom.createDocument(None, "root", None)

topElement = document.documentElement
firstElement = document.createElement("element")
topElement.appendChild(firstElement)
textNode = document.createTextNode("Some text here")
firstElement.appendChild(textNode)

xmlString = document.toprettyxml(" " * 4)
