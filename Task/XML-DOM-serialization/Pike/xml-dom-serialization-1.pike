object dom = Parser.XML.Tree.SimpleRootNode();
dom->add_child(Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_HEADER, "", ([]), ""));
object node = Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_ELEMENT, "root", ([]), "");
dom->add_child(node);

object subnode = Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_ELEMENT, "element", ([]), "");
node->add_child(subnode);

node = subnode;
subnode = Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), "Some text here");
node->add_child(subnode);

dom->render_xml();
Result: "<?xml version='1.0' encoding='utf-8'?><root><element>Some text here</element></root>"
