#include <libxml/parser.h>
#include <libxml/tree.h>

int main()
{
  xmlDoc *doc = xmlNewDoc("1.0");
  xmlNode *root = xmlNewNode(NULL, BAD_CAST "root");
  xmlDocSetRootElement(doc, root);

  xmlNode *node = xmlNewNode(NULL, BAD_CAST "element");
  xmlAddChild(node, xmlNewText(BAD_CAST "some text here"));
  xmlAddChild(root, node);

  xmlSaveFile("myfile.xml", doc);

  xmlFreeDoc(doc);
  xmlCleanupParser();
}
