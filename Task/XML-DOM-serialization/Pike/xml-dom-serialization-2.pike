object make_xml_node(array|string in, void|int level)
{
    level++;
    if (stringp(in))
        return Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), in);
    else
    {
        object node = Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_ELEMENT, in[0], in[1], "");
        foreach(in[2..];; array|string child)
        {
            node->add_child(make_xml_node(child, level));
        }
        return node;
    }
}

object make_xml_tree(array input)
{
    object dom = Parser.XML.Tree.SimpleRootNode();
    dom->add_child(Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_HEADER, "", ([]), ""));
    dom->add_child(make_xml_node(input));
    return dom;
}

array input = ({ "root", ([]), ({ "element", ([]), "Some text here" }) });
make_xml_tree(input)->render_xml();
Result: "<?xml version='1.0' encoding='utf-8'?><root><element>Some text here</element></root>"
