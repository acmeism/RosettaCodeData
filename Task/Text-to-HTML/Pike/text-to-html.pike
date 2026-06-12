// function to calculate the average line length (not used yet below)
int linelength(array lines)
{
    array sizes = sizeof(lines[*])-({0});
    sizes = sort(sizes);

    // only consider the larger half of lines minus the top 5%
    array larger = sizes[sizeof(sizes)/2..sizeof(sizes)-sizeof(sizes)/20];

    int averagelarger = `+(@larger)/sizeof(larger);
    return averagelarger;
}

array mark_up(array lines)
{
    array markup = ({});

    // find special lines
    foreach(lines; int index; string line)
    {
        string strippedline = String.trim_whites(line);
        if (sizeof(strippedline))
        {
            string firstchar = strippedline[0..0];
            int pos = search(line, firstchar);

            if (lines[index-1]-" "-"\t" =="" && lines[index+1]-" "-"\t" =="")
                markup +=({ ({ "heading", strippedline, pos }) });
            else if (firstchar == "*")
                markup += ({ ({ "bullet", strippedline, pos }) });
            else if ( (<"0","1","2","3","4","5","6","7","8","9">)[firstchar] )
                markup += ({ ({ "number", strippedline, pos }) });
            else if (pos > 0)
                markup += ({ ({ "indent", strippedline, pos }) });
            else
                markup += ({ ({ "regular", strippedline, pos }) });
        }
        else markup += ({ ({ "empty" }) });
    }

    foreach(markup; int index; array line)
    {
        if (index > 0 && index < sizeof(markup)-1 )
        {
            if (line[0] == "regular" && markup[index-1][0] != "regular" && markup[index+1][0] != "regular")
                line[0] = "heading";
        }
    }

    //find paragraphs
    foreach(markup; int index; array line)
    {
        if (index > 0 && index < sizeof(markup)-1 )
        {
            if (line[0] == "empty" && markup[index-1][0] == "regular" && markup[index+1][0] == "regular")
                line[0] = "new paragraph";
            else if (line[0] == "empty" && markup[index-1][0] == "regular" && markup[index+1][0] != "regular")
                line[0] = "end paragraph";
            else if (line[0] == "empty" && markup[index-1][0] != "regular" && markup[index+1][0] == "regular")
                line[0] = "begin paragraph";
        }
    }
    return markup;
}

object make_tree(array markup)
{
    object root = Parser.XML.Tree.SimpleRootNode();
    object newline = Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), "\n");
    array current = ({ Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_ELEMENT, "div", ([]), "") });
    root->add_child(current[-1]);

    foreach (markup; int index; array line)
    {
        switch(line[0])
        {
            case "heading":
                      current[-1]->add_child(newline);
                      object h = Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_ELEMENT, "h3", ([]), "");
                      h->add_child(Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), line[1]));
                      current[-1]->add_child(h);
                      current[-1]->add_child(newline);
                  break;
            case "bullet":
            case "number":
                      if (current[-1]->get_tag_name() == "li")
                          current = Array.pop(current)[1];
                      current[-1]->add_child(newline);
                      object li = Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_ELEMENT, "li", ([]), "");
                      li->add_child(Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), line[1]));
                      current[-1]->add_child(li);
                      current = Array.push(current, li);
                  break;
            case "indent":
                      if (markup[index-1][0] != "bullet" && markup[index-1][0] != "number")
                          current = Array.pop(current)[1];
                      current[-1]->add_child(Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), line[1]));
                  break;
            case "new paragraph":
                      current = Array.pop(current)[1];
                      current[-1]->add_child(newline);
            case "begin paragraph":
                      object p = Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_ELEMENT, "p", ([]), "");
                      current[-1]->add_child(p);
                      current = Array.push(current, p);
                 break;
            case "end paragraph":
                      current = Array.pop(current)[1];
                      current[-1]->add_child(newline);
                 break;
            case "regular":
                      current[-1]->add_child(Parser.XML.Tree.SimpleNode(Parser.XML.Tree.XML_TEXT, "", ([]), line[1]));
            case "empty":
                  break;
        }
    }
    return root;
}
