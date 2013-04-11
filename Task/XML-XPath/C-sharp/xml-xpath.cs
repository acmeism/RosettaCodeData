XmlReader XReader;

// Either read the xml from a string ...
XReader = XmlReader.Create(new StringReader("<inventory title=... </inventory>"));

// ... or read it from the file system.
XReader = XmlReader.Create("xmlfile.xml");

// Create a XPathDocument object (which implements the IXPathNavigable interface)
// which is optimized for XPath operation. (very fast).
IXPathNavigable XDocument = new XPathDocument(XReader);

// Create a Navigator to navigate through the document.
XPathNavigator Nav = XDocument.CreateNavigator();
Nav = Nav.SelectSingleNode("//item");

// Move to the first element of the selection. (if available).
if(Nav.MoveToFirst())
{
  Console.WriteLine(Nav.OuterXml); // The outer xml of the first item element.
}

// Get an iterator to loop over multiple selected nodes.
XPathNodeIterator Iterator = XDocument.CreateNavigator().Select("//price");

while (Iterator.MoveNext())
{
  Console.WriteLine(Iterator.Current.Value);
}

Iterator = XDocument.CreateNavigator().Select("//name");

// Use a generic list.
List<string> NodesValues = new List<string>();

while (Iterator.MoveNext())
{
  NodesValues.Add(Iterator.Current.Value);
}

// Convert the generic list to an array and output the count of items.
Console.WriteLine(NodesValues.ToArray().Length);
