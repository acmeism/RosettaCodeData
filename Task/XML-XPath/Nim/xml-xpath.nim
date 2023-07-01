import sequtils, strutils

const LibXml = "libxml2.so"

type

  XmlDocPtr = pointer

  XmlXPathContextPtr = pointer

  XmlElementKind = enum
    xmlElementNode =      1
    xmlAttributeNode =    2
    xmlTextNode =         3
    xmlCdataSectionNode = 4
    xmlEntityRefNode =    5
    xmlEntityNode =       6
    xmlPiNode =           7
    xmlCommentNode =      8
    xmlDocumentNode =     9
    xmlDocumentTypeNode = 10
    xmlDocumentFragNode = 11
    xmlNotationNode =     12
    xmlHtmlDocumentNode = 13
    xmlDtdNode =          14
    xmlElementDecl =      15
    xmlAttributeDecl =    16
    xmlEntityDecl =       17
    xmlNamespaceDecl =    18
    xmlXincludeStart =    19
    xmlXincludeEnd =      20

  XmlNsKind = XmlElementKind

  XmlNsPtr = ptr XmlNs
  XmlNs = object
    next: XmlNsPtr
    kind: XmlNsKind
    href: cstring
    prefix: cstring
    private: pointer
    context: XmlDocPtr

  XmlAttrPtr = pointer

  XmlNodePtr = ptr XmlNode
  XmlNode = object
    private: pointer
    kind: XmlElementKind
    name: cstring
    children: XmlNodePtr
    last: XmlNodePtr
    parent: XmlNodePtr
    next: XmlNodePtr
    prev: XmlNodePtr
    doc: XmlDocPtr
    ns: XmlNsPtr
    content: cstring
    properties: XmlAttrPtr
    nsDef: XmlNsPtr
    psvi: pointer
    line: cushort
    extra: cushort

  XmlNodeSetPtr = ptr XmlNodeSet
  XmlNodeSet = object
    nodeNr: cint
    nodeMax: cint
    nodeTab: ptr UncheckedArray[XmlNodePtr]

  XmlPathObjectKind = enum
      xpathUndefined
      xpathNodeset
      xpathBoolean
      xpathNumber
      xpathString
      xpathPoint
      xpathRange
      xpathLocationset
      xpathUsers
      xpathXsltTree

  XmlXPathObjectPtr = ptr XmlXPathObject
  XmlXPathObject = object
    kind: XmlPathObjectKind
    nodeSetVal: XmlNodeSetPtr
    boolVal: cint
    floatVal: cdouble
    stringVal: cstring
    user: pointer
    index: cint
    user2: pointer
    index2: cint

  XmlSaveCtxtPtr = pointer

  XmlBufferPtr = pointer


# Declaration of needed "libxml2" procedures.
proc xmlParseFile(docName: cstring): XmlDocPtr
  {.cdecl, dynlib: LibXml, importc: "xmlParseFile".}

proc xmlXPathNewContext(doc: XmlDocPtr): XmlXPathContextPtr
  {.cdecl, dynlib: LibXml, importc: "xmlXPathNewContext".}

proc xmlXPathEvalExpression(str: cstring; ctxt: XmlXPathContextPtr): XmlXPathObjectPtr
  {.cdecl, dynlib: LibXml, importc: "xmlXPathEvalExpression".}

proc xmlXPathFreeContext(ctxt: XmlXPathContextPtr)
  {.cdecl, dynlib: LibXml, importc: "xmlXPathFreeContext".}

proc xmlXPathFreeObject(obj: XmlXPathObjectPtr)
  {.cdecl, dynlib: LibXml, importc: "xmlXPathFreeObject".}

proc xmlSaveToBuffer(vuffer: XmlBufferPtr; encoding: cstring; options: cint): XmlSaveCtxtPtr
  {.cdecl, dynlib: LibXml, importc: "xmlSaveToBuffer".}

proc xmlBufferCreate(): XmlBufferPtr
  {.cdecl, dynlib: LibXml, importc: "xmlBufferCreate".}

proc xmlBufferFree(buf: XmlBufferPtr)
  {.cdecl, dynlib: LibXml, importc: "xmlBufferCreate".}

proc xmlBufferContent(buf: XmlBufferPtr): cstring
  {.cdecl, dynlib: LibXml, importc: "xmlBufferContent".}

proc xmlSaveTree(ctxt: XmlSaveCtxtPtr; cur: XmlNodePtr): clong
  {.cdecl, dynlib: LibXml, importc: "xmlSaveTree".}

proc xmlSaveClose(ctxt: XmlSaveCtxtPtr)
  {.cdecl, dynlib: LibXml, importc: "xmlSaveClose".}


proc `$`(node: XmlNodePtr): string =
  ## Return the representation of a node.
  let buffer = xmlBufferCreate()
  let saveContext = xmlSaveToBuffer(buffer, nil, 0)
  discard saveContext.xmlSaveTree(node)
  saveContext.xmlSaveClose()
  result = $buffer.xmlBufferContent()
  xmlBufferFree(buffer)


iterator nodes(xpath: string; context: XmlXPathContextPtr): XmlNodePtr =
  ## Yield the nodes which fit the XPath request.
  let xpathObj = xmlXPathEvalExpression(xpath, context)
  if xpathObj.isNil:
    quit "Failed to evaluate XPath: " & xpath, QuitFailure
  assert xpathObj.kind == xpathNodeset
  let nodeSet = xpathObj.nodeSetVal
  if not nodeSet.isNil:
    for i in 0..<nodeSet.nodeNr:
      yield nodeSet.nodeTab[i]
  xmlXPathFreeObject(xpathObj)


# Load and parse XML file.
let doc = xmlParseFile("xpath_test.xml")
if doc.isNil:
  quit "Unable to load and parse document", QuitFailure

# Create an XPath context.
let context = xmlXPathNewContext(doc)
if context.isNil:
  quit "Failed to create XPath context", QuitFailure

var xpath = "//section[1]/item[1]"
echo "Request $#:".format(xpath)
for node in nodes(xpath, context):
  echo node
echo()

xpath = "//price/text()"
echo "Request $#:".format(xpath)
for node in nodes(xpath, context):
  echo node.content
echo()

xpath = "//name"
echo "Request $#:".format(xpath)
let names = toSeq(nodes(xpath, context)).mapIt(it.children.content)
echo names

xmlXPathFreeContext(context)
