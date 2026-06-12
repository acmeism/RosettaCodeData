/* XML_validation.wren */

class Args {
    foreign static xmlFilename

    foreign static xsdFilename
}

foreign class XmlSchemaPtr {
    construct new() {}
}

foreign class XmlSchemaParserCtxtPtr {
    construct new(url) {}

    foreign parse(schema)

    foreign freeParserCtxt()
}

foreign class XmlSchemaValidCtxtPtr {
    construct new(schema) {}

    foreign validateFile(filename, options)

    foreign freeValidCtxt()
}

var xmlFilename = Args.xmlFilename
var xsdFilename = Args.xsdFilename

// parse xml schema file
var parserCtxt = XmlSchemaParserCtxtPtr.new(xsdFilename)
var schema = XmlSchemaPtr.new()
parserCtxt.parse(schema)
parserCtxt.freeParserCtxt()

// validate xml file using schema
var validCtxt = XmlSchemaValidCtxtPtr.new(schema)
var res = validCtxt.validateFile(xmlFilename, 0)
if (res == 0) {
    System.print("'%(xmlFilename)' validates.")
} else if (res == -1) {
    System.print("'%(xmlFilename)' validation generated an internal error.")
} else {
    System.print("'%(xmlFilename)' fails to validate.")
}
validCtxt.freeValidCtxt()
