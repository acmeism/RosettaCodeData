#include <libxml/xmlschemastypes.h>

int main(int argC, char** argV)
{
	if (argC <= 2) {
		printf("Usage: %s <XML Document Name> <XSD Document Name>\n", argV[0]);
		return 0;
	}
	
	xmlDocPtr doc;
	xmlSchemaPtr schema = NULL;
	xmlSchemaParserCtxtPtr ctxt;
	char *XMLFileName = argV[1];
	char *XSDFileName = argV[2];
	int ret;

	xmlLineNumbersDefault(1);

	ctxt = xmlSchemaNewParserCtxt(XSDFileName);

	xmlSchemaSetParserErrors(ctxt, (xmlSchemaValidityErrorFunc) fprintf, (xmlSchemaValidityWarningFunc) fprintf, stderr);
	schema = xmlSchemaParse(ctxt);
	xmlSchemaFreeParserCtxt(ctxt);


	doc = xmlReadFile(XMLFileName, NULL, 0);

	if (doc == NULL){
		fprintf(stderr, "Could not parse %s\n", XMLFileName);
	}
	else{
		xmlSchemaValidCtxtPtr ctxt;

		ctxt = xmlSchemaNewValidCtxt(schema);
		xmlSchemaSetValidErrors(ctxt, (xmlSchemaValidityErrorFunc) fprintf, (xmlSchemaValidityWarningFunc) fprintf, stderr);
		ret = xmlSchemaValidateDoc(ctxt, doc);
		
		if (ret == 0){
			printf("%s validates\n", XMLFileName);
		}
		else if (ret > 0){
			printf("%s fails to validate\n", XMLFileName);
		}
		else{
			printf("%s validation generated an internal error\n", XMLFileName);
		}
		xmlSchemaFreeValidCtxt(ctxt);
		xmlFreeDoc(doc);
	}


	if(schema != NULL)
		xmlSchemaFree(schema);

	xmlSchemaCleanupTypes();
	xmlCleanupParser();
	xmlMemoryDump();

	return 0;
}
