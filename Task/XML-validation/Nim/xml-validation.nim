import os, strformat

const LibXml = "libxml2.so"

type
  XmlSchemaParserCtxtPtr = pointer
  XmlSchemaPtr = pointer
  XmlSchemaValidCtxtPtr = pointer


# Declaration of needed "libxml2" procedures.

proc xmlSchemaNewParserCtxt(url: cstring): XmlSchemaParserCtxtPtr
  {.cdecl, dynlib: LibXml, importc: "xmlSchemaNewParserCtxt".}

proc xmlSchemaParse(ctxt: XmlSchemaParserCtxtPtr): XmlSchemaPtr
  {.cdecl, dynlib: LibXml, importc: "xmlSchemaParse".}

proc xmlSchemaFreeParserCtxt(ctxt: XmlSchemaParserCtxtPtr)
  {.cdecl, dynlib: LibXml, importc: "xmlSchemaFreeParserCtxt".}

proc xmlSchemaNewValidCtxt(schema: XmlSchemaPtr): XmlSchemaValidCtxtPtr
  {.cdecl, dynlib: LibXml, importc: "xmlSchemaNewValidCtxt".}

proc xmlSchemaValidateFile(ctxt: XmlSchemaValidCtxtPtr; filename: cstring; options: cint): cint
  {.cdecl, dynlib: LibXml, importc: "xmlSchemaValidateFile".}

proc xmlSchemaFreeValidCtxt(ctxt: XmlSchemaValidCtxtPtr)
  {.cdecl, dynlib: LibXml, importc: "xmlSchemaFreeValidCtxt".}


if paramCount() != 2:
  quit &"Usage: {getAppFilename().lastPathPart} <XML Document Name> <XSD Document Name", QuitFailure

let xmlFilename = paramStr(1)
let xsdFilename = paramStr(2)

# Parse XML schema file.
let parserCtxt = xmlSchemaNewParserCtxt(xsdFilename)
let schema = parserCtxt.xmlSchemaParse()
parserCtxt.xmlSchemaFreeParserCtxt()

# Validate XML file using XML schema.
let validCtxt = schema.xmlSchemaNewValidCtxt()
case validCtxt.xmlSchemaValidateFile(xmlFilename, 0)
of 0:
  echo &"“{xmlFilename}” validates."
of -1:
  echo &"“{xmlFilename}” validation generated an internal error."
else:
  echo &"“{xmlFilename}” fails to validate."
validCtxt.xmlSchemaFreeValidCtxt()
