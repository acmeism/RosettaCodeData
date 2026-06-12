using LightXML

const Xptr = LightXML.Xptr

function validate(url::String, schemafile::String)
    ctxt = ccall((:xmlSchemaNewParserCtxt, LightXML.libxml2), Xptr, (Cstring,), schemafile)
    ctxt != C_NULL || throw(LightXML.XMLNoRootError())
    schema = ccall((:xmlSchemaParse, LightXML.libxml2), Xptr, (Xptr,), ctxt)
    schema != C_NULL || throw(LightXML.XMLNoRootError())
    ccall((:xmlSchemaFreeParserCtxt, LightXML.libxml2), Cvoid, (Xptr,), ctxt)
    ctxt = ccall((:xmlSchemaNewValidCtxt, LightXML.libxml2), Xptr, (Xptr,), schema)
    err = ccall((:xmlSchemaValidateFile, LightXML.libxml2),
        Cint, (Ptr{LightXML.xmlBuffer}, Cstring), ctxt, url)
    return err == 0 ? true : false
end

function xsdvalidatexml()
    if length(ARGS) != 2
        println("		Usage: julia ", PROGRAM_FILE, ", xmlfilename xsdfilename")
    elseif validate(ARGS[1], ARGS[2])
        println("File ", ARGS[1], " validates as correct XML using the XSD file ", ARGS[2], ".")
    else
        println("File ", ARGS[1]. "does not validate.")
    end
end

xsdvalidatexml()
