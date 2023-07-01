from xml.etree import ElementTree as et

root = et.Element("root")
et.SubElement(root, "element").text = "Some text here"
xmlString = et.tostring(root)
