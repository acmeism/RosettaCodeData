// Kotlin Native v0.6

import kotlinx.cinterop.*
import platform.posix.*
import libxml_schemas.*

fun err(ctx: COpaquePointer?, msg: CPointer<ByteVar>?, extra: CPointer<ByteVar>?) {
    val fp = ctx?.reinterpret<FILE>()
    fprintf(fp, msg?.toKString(), extra?.toKString())
}

fun warn(ctx: COpaquePointer?, msg: CPointer<ByteVar>?, extra: CPointer<ByteVar>?) {
    err(ctx, msg, extra)
}

fun main(args: Array<String>) {
    if (args.size != 2) {
        println("You need to pass exactly 2 command line arguments, namely:")
        println("    <XML Document Name> <XSD Document Name>")
        return
    }

    val xmlFileName = args[0]
    val xsdFileName = args[1]
    xmlLineNumbersDefault(1)
    val ctxt = xmlSchemaNewParserCtxt(xsdFileName)

    xmlSchemaSetParserErrors(
        ctxt,
        staticCFunction(::err) as xmlSchemaValidityErrorFunc?,
        staticCFunction(::warn) as xmlSchemaValidityWarningFunc?,
        stderr
    )

    val schema = xmlSchemaParse(ctxt)
    xmlSchemaFreeParserCtxt(ctxt)

    val doc = xmlReadFile(xmlFileName, null, 0)
    if (doc == null) {
        println("Could not parse $xmlFileName")
    }
    else {
        val ctxt2 = xmlSchemaNewValidCtxt(schema)

        xmlSchemaSetValidErrors(
            ctxt2,
            staticCFunction(::err) as xmlSchemaValidityErrorFunc?,
            staticCFunction(::warn) as xmlSchemaValidityWarningFunc?,
            stderr
        )

        val ret = xmlSchemaValidateDoc(ctxt2, doc)
        if (ret == 0)
            println("$xmlFileName validates")
        else if (ret > 0)
            println("$xmlFileName fails to validate")
        else
            println("$xmlFileName generated an internal error")
        xmlSchemaFreeValidCtxt(ctxt2)
        xmlFreeDoc(doc)
    }

    if (schema != null) xmlSchemaFree(schema)
    xmlSchemaCleanupTypes()
    xmlCleanupParser()
    xmlMemoryDump()
}
