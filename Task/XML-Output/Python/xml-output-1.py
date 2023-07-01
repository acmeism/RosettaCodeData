>>> from xml.etree import ElementTree as ET
>>> from itertools import izip
>>> def characterstoxml(names, remarks):
	root = ET.Element("CharacterRemarks")
	for name, remark in izip(names, remarks):
		c = ET.SubElement(root, "Character", {'name': name})
		c.text = remark
	return ET.tostring(root)

>>> print characterstoxml(
	names = ["April", "Tam O'Shanter", "Emily"],
	remarks = [ "Bubbly: I'm > Tam and <= Emily",
		    'Burns: "When chapman billies leave the street ..."',
		    'Short & shrift' ] ).replace('><','>\n<')
