object indent_xml(object parent, void|int indent_text, void|int level)
{
    int subnodes = false;
    foreach(parent->get_children();; object child)
    {
        if (child->get_node_type() == Parser.XML.Tree.XML_ELEMENT ||
            (child->get_node_type() == Parser.XML.Tree.XML_TEXT && indent_text))
        {
            subnodes = true;
            parent->add_child_before(Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), "\r\n"+"    "*level), child);
            indent_xml(child, indent_text, level+1);
        }
    }
    if (subnodes && level)
        parent->add_child(Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), "\r\n"+"    "*(level-1)));
    return parent;
}


indent_xml(make_xml_tree(input))->render_xml();
Result: "<?xml version='1.0' encoding='utf-8'?>\r\n"
        "<root>\r\n"
        "    <element>Some text here</element>\r\n"
        "</root>"

indent_xml(make_xml_tree(input), 1)->render_xml();
Result: "<?xml version='1.0' encoding='utf-8'?>\r\n"
        "<root>\r\n"
        "    <element>\r\n"
        "        Some text here\r\n"
        "    </element>\r\n"
        "</root>"
