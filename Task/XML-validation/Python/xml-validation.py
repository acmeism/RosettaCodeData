#!/bin/python
from __future__ import print_function
import lxml
from lxml import etree

if __name__=="__main__":

	parser = etree.XMLParser(dtd_validation=True)
	schema_root = etree.XML('''\
		<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
			<xsd:element name="a" type="xsd:integer"/>
		</xsd:schema>
		''')
	schema = etree.XMLSchema(schema_root)

	#Good xml
	parser = etree.XMLParser(schema = schema)
	try:
		root = etree.fromstring("<a>5</a>", parser)
		print ("Finished validating good xml")
	except lxml.etree.XMLSyntaxError as err:
		print (err)

	#Bad xml
	parser = etree.XMLParser(schema = schema)
	try:
		root = etree.fromstring("<a>5<b>foobar</b></a>", parser)
	except lxml.etree.XMLSyntaxError as err:
		print (err)
