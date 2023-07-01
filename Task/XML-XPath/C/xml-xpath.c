#include <libxml/parser.h>
#include <libxml/xpath.h>

xmlDocPtr getdoc (char *docname) {
	xmlDocPtr doc;
	doc = xmlParseFile(docname);

	return doc;
}

xmlXPathObjectPtr getnodeset (xmlDocPtr doc, xmlChar *xpath){
	
	xmlXPathContextPtr context;
	xmlXPathObjectPtr result;

	context = xmlXPathNewContext(doc);

	result = xmlXPathEvalExpression(xpath, context);
	xmlXPathFreeContext(context);

	return result;
}

int main(int argc, char **argv) {

	if (argc <= 2) {
		printf("Usage: %s <XML Document Name> <XPath expression>\n", argv[0]);
		return 0;
	}
	
	char *docname;
	xmlDocPtr doc;
	xmlChar *xpath = (xmlChar*) argv[2];
	xmlNodeSetPtr nodeset;
	xmlXPathObjectPtr result;
	int i;
	xmlChar *keyword;

	docname = argv[1];
	doc = getdoc(docname);
	result = getnodeset (doc, xpath);
	if (result) {
		nodeset = result->nodesetval;
		for (i=0; i < nodeset->nodeNr; i++) {
		xmlNodePtr titleNode = nodeset->nodeTab[i];
		keyword = xmlNodeListGetString(doc, titleNode->xmlChildrenNode, 1);
		printf("Value %d: %s\n",i+1, keyword);
		xmlFree(keyword);
		}
		xmlXPathFreeObject (result);
	}
	xmlFreeDoc(doc);
	xmlCleanupParser();
	return 0;
}
