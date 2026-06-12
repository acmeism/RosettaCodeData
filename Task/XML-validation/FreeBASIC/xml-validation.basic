#include once "crt/stdio.bi"
#include once "crt/stdlib.bi"
#include once "libxml/tree.bi"
#include once "libxml/parser.bi"

'' Load the XML document
dim as xmlDocPtr doc = xmlReadFile("document.xml", NULL, 0)
if doc = NULL then
    print "Error opening XML document."
    end 1
end if

'' Load the XSD schema
dim as xmlSchemaParserCtxtPtr ctxt = xmlSchemaNewParserCtxt("schema.xsd")
if ctxt = NULL then
    print "Error opening XSD schema."
    xmlFreeDoc(doc)
    end 1
end if

'' Parse the XSD schema
dim as xmlSchemaPtr schema = xmlSchemaParse(ctxt)
if schema = NULL then
    print "Error parsing XSD schema."
    xmlSchemaFreeParserCtxt(ctxt)
    xmlFreeDoc(doc)
    end 1
end if

'' Create a validation context
dim as xmlSchemaValidCtxtPtr vctxt = xmlSchemaNewValidCtxt(schema)
if vctxt = NULL then
    print "Error creating validation context."
    xmlSchemaFree(schema)
    xmlSchemaFreeParserCtxt(ctxt)
    xmlFreeDoc(doc)
    end 1
end if

'' Validate the XML document against the XSD schema
if xmlSchemaValidateDoc(vctxt, doc) = 0 then
    print "The XML document is valid according to the XSD schema."
else
    print "The XML document is not valid according to the XSD schema."
end if

'' Free resources
xmlSchemaFreeValidCtxt(vctxt)
xmlSchemaFree(schema)
xmlSchemaFreeParserCtxt(ctxt)
xmlFreeDoc(doc)
xmlCleanupParser()
